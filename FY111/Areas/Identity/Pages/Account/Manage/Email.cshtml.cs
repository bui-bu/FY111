﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Text.Encodings.Web;
using System.Linq;
using System.Threading.Tasks;
using FY111.Areas.Identity.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.WebUtilities;
using FY111.Resources;
using Microsoft.Extensions.Localization;

namespace FY111.Areas.Identity.Pages.Account.Manage
{
    public partial class EmailModel : PageModel
    {
        private readonly UserManager<FY111User> _userManager;
        private readonly SignInManager<FY111User> _signInManager;
        private readonly IEmailSender _emailSender;
        private readonly IStringLocalizer<EmailModel> _localizer;

        public EmailModel(
            UserManager<FY111User> userManager,
            SignInManager<FY111User> signInManager,
            IEmailSender emailSender,
            IStringLocalizer<EmailModel> localizer)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _emailSender = emailSender;
            _localizer = localizer;
        }

        public string Username { get; set; }

        public string Email { get; set; }

        public bool IsEmailConfirmed { get; set; }

        [TempData]
        public string StatusMessage { get; set; }

        [BindProperty]
        public InputModel Input { get; set; }

        public class InputModel
        {
            [Required(ErrorMessageResourceName = "Required", ErrorMessageResourceType = typeof(ErrorMessageResources))]
            [EmailAddress]
            [Display(Name = "NewEmail", ResourceType = typeof(DisplayAttributeResources))]
            public string NewEmail { get; set; }
        }

        private async Task LoadAsync(FY111User user)
        {
            var email = await _userManager.GetEmailAsync(user);
            Email = email;

            Input = new InputModel
            {
                NewEmail = email,
            };

            IsEmailConfirmed = await _userManager.IsEmailConfirmedAsync(user);
        }

        public async Task<IActionResult> OnGetAsync()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return NotFound($"Unable to load user with ID '{_userManager.GetUserId(User)}'.");
            }

            await LoadAsync(user);
            return Page();
        }

        public async Task<IActionResult> OnPostChangeEmailAsync()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return NotFound($"Unable to load user with ID '{_userManager.GetUserId(User)}'.");
            }

            if (!ModelState.IsValid)
            {
                await LoadAsync(user);
                return Page();
            }

            var email = await _userManager.GetEmailAsync(user);
            if (Input.NewEmail != email)
            {
                var userId = await _userManager.GetUserIdAsync(user);
                var code = await _userManager.GenerateChangeEmailTokenAsync(user, Input.NewEmail);
                var callbackUrl = Url.Page(
                    "/Account/ConfirmEmailChange",
                    pageHandler: null,
                    values: new { userId = userId, email = Input.NewEmail, code = code },
                    protocol: Request.Scheme);
                await _emailSender.SendEmailAsync(
                    Input.NewEmail,
                    _localizer["Confirm your email"],
                    _localizer["Please confirm your account by <a href='{0}'>clicking here</a>.", HtmlEncoder.Default.Encode(callbackUrl)]);

                StatusMessage = _localizer["Confirmation link to change email sent. Please check your email."];
                return RedirectToPage();
            }

            StatusMessage = _localizer["Your email is unchanged."];
            return RedirectToPage();
        }

        public async Task<IActionResult> OnPostSendVerificationEmailAsync()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return NotFound($"Unable to load user with ID '{_userManager.GetUserId(User)}'.");
            }

            if (!ModelState.IsValid)
            {
                await LoadAsync(user);
                return Page();
            }

            var userId = await _userManager.GetUserIdAsync(user);
            var email = await _userManager.GetEmailAsync(user);
            var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
            code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));
            var callbackUrl = Url.Page(
                "/Account/ConfirmEmail",
                pageHandler: null,
                values: new { area = "Identity", userId = userId, code = code },
                protocol: Request.Scheme);
            await _emailSender.SendEmailAsync(
                email,
                _localizer["Confirm your email"],
                _localizer["Please confirm your account by <a href='{0}'>clicking here</a>.", HtmlEncoder.Default.Encode(callbackUrl)]);

            StatusMessage = _localizer["Verification email sent. Please check your email."];
            return RedirectToPage();
        }
    }
}
