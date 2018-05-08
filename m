From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 00/13] firmware_loader changes for v4.18
Date: Tue, 8 May 2018 15:45:02 -0700
Message-ID: <CAGXu5jJ=9XKn=z1T16iV-BoN88QLh7q+OicZxc5TvEjioriGMA@mail.gmail.com>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, maco@android.com, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, Hans de Goede <hdegoede@redhat.com>, Andres Rodriguez <andresx7@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Jakub Kicinski <kubakici@wp.pl>, Shuah Khan <shuah@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, David Howells <dhowells@redhat.com>, pali.rohar@gmail.com, Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Nicolas Broeking <nbroeking@me.com>, Vikram
List-Id: linux-scsi@vger.kernel.org

On Tue, May 8, 2018 at 11:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> Greg,
>
> Here is what I have queued up for the firmware_loader for v4.18. It
> includes a slew of cleanup work, and the new firmware_request_nowarn()
> which is quiet but enables the sysfs fallback mechanism. I've gone ahead
> and also queued up a few minor fixes for the firmware loader documentation
> which have come up recently. These changes are available on my git tree
> both based on linux-next [0] and Linus' latest tree [1]. Folks working
> on new developments for the firmware loader can use my linux-next
> branch 20180508-firmware_loader_for-v4.18-try2 for now.
>
> 0-day sends its blessings.
>
> The patches from Mimi's series still require a bit more discussion and
> review. The discussion over the EFI firmware fallback mechanism is still
> ongoing.
>
> As for the rename that you wanted, perhaps we can do this late in the
> merge window considering we're at rc4 now. I can prep something up for
> that later.
>
> Question, and specially rants are warmly welcomed.

I sent some typo catches, but with those fixed, please consider the
whole series:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
