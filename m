From: Patrizio Bassi <patrizio.bassi@gmail.com>
Subject: Re: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 13:37:55 +0100
Message-ID: <43F07DA3.6080702@gmail.com>
References: <Pine.LNX.4.64.0602121709240.3691@g5.osdl.org>	<20060212190520.244fcaec.akpm@osdl.org> <s5hk6bz4gca.wl%tiwai@suse.de>
Reply-To: patrizio.bassi@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <s5hk6bz4gca.wl%tiwai@suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, =?ISO-8859-1?Q?Gerrit_Bruchh=E4us?= =?ISO-8859-1?Q?er?= <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, =?ISO-8859-1?Q?Bj=F6rn_Nilsson?= <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andrew.vasquez@ql>
List-Id: linux-scsi@vger.kernel.org

Takashi Iwai ha scritto:
> At Sun, 12 Feb 2006 19:05:20 -0800,
> Andrew Morton wrote:
>   
>> - Patrizio Bassi <patrizio.bassi@gmail.com> has an alsa suspend
>>   regression ("alsa suspend/resume continues to fail for ens1370")
>>     
>
> It's not a "regression".  PM didn't work with ens1370 at all in the
> eralier version.
>
> About the problem there, I have no idea now what's wrong.  The
> suspend-to-disk works fine if the driver is built as module but not as
> built-in kernel.
>
>
>   
i wrote "regression" because before (ehm...exactly don't know...about
2.6.14 time)
after suspend i had to restart my distro's mixer values service or i
couldn't hear anything.
and...ok..it was boring but worked.

now i get 0x660 errors if i try to restore values and device seems dead,
just flood the syslog.
sound apps slow down (like 100% cpu usage) and no sound produced.

only fix is reboot.


>> - ghrt <ghrt@dial.kappa.ro> reports an alsa regression ("PROBLEM: SB
>>   Live!  5.1 (emu10k1, rev.  0a) doesn't work with 2.6.15")
>>     
>
> I couldn't find this bugzilla entry...
>
>
> Takashi
>
>   

