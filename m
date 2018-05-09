From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 05/13] firmware_loader: enhance Kconfig documentation
 over FW_LOADER
Date: Wed, 9 May 2018 16:01:09 -0700
Message-ID: <CAGXu5jLn0m_9j=r=x1JefRVEYMvR4Q--e8pCufZyoVQkWe507A@mail.gmail.com>
References: <20180508181247.19431-1-mcgrof@kernel.org> <20180508181247.19431-6-mcgrof@kernel.org>
 <CAGXu5jJXMxx2Xna_M_g1wsS59XnYKqHAGdxhzDtk3PhnLL-gQQ@mail.gmail.com> <20180509205544.GW27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180509205544.GW27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, maco@android.com, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, bjorn.andersson@linaro.org, Tom Gundersen <teg@jklm.no>, wagi@monom.org, Hans de Goede <hdegoede@redhat.com>, Andres Rodriguez <andresx7@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Jakub Kicinski <kubakici@wp.pl>, Shuah Khan <shuah@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, David Howells <dhowells@redhat.com>, pali.rohar@gmail.com, Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Nicolas Broeking <nbroeking@me.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 9, 2018 at 1:55 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, May 08, 2018 at 03:42:33PM -0700, Kees Cook wrote:
>> On Tue, May 8, 2018 at 11:12 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > +         This used to be the default firmware loading facility, and udev used
>> > +         to listen for uvents to load firmware for the kernel. The firmware
>> > +         loading facility functionality in udev has been removed, as such it
>> > +         can no longer be relied upon as a fallback mechanism. Linux no longer
>> > +         relies on or uses a fallback mechanism in userspace. If you need to
>> > +         rely on one refer to the permissively licensed firmwared:
>>
>> Typo: firmware
>
> Thanks fixed all typos except this one, this one is meant to be firmwared as
> that is the name of the project, the url is below.
>
>>
>> > +
>> > +         https://github.com/teg/firmwared

Oh! Yes, hah. :) Thanks!

-Kees

-- 
Kees Cook
Pixel Security
