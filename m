From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aix7xxx driver 5.2.4/5.2.0 vs. 6.2.5 with onboard aic7896/97 Ultra2 controller
Date: Tue, 07 May 2002 08:31:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205071431.g47EVI906181@aslan.scsiguy.com>
References: <3CD7E47A.10809@hol.gr>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 07 May 2002 17:28:10 +0300."
             <3CD7E47A.10809@hol.gr>
List-Id: linux-scsi@vger.kernel.org
To: "Dimitrios P. Bouras" <dbouras@hol.gr>
Cc: linux-scsi@vger.kernel.org

>Hello all,
>
>I have recently switched from kernel version 2.2.20 to 2.4.18. The
>problem I've had is with the new aic7xxx driver. In short, it seems
>to have the same (possibly reasonable but, in effect, undesirable)
>behavior as the SCSI-BIOS for the onboard aic7896/97 Ultra2 controller
>on my Gigabyte GA-6BXDU motherboard: it fails to enable the full 80
>mb/s transfer rate on my 2 hard-drives, as well as 20 mb/s and 10 mb/s
>on my cdrom and cd recorder respectively. The old driver works like a
>charm. Similarly the older Adaptec BIOS detected all four devices
>correctly, but I had to upgrade when I installed a Coppermine processor.
>I am currently forced to use the old driver under 2.4.18, but would like
>to resolve this problem.

Go into the SCSI-Select BIOS option for each channel.  Set some speed
other than the fastest speed for all devices.  Save the result.  Go
back into SCSI-Select and select the fastest speed.  The serial eeprom
will now have the correct values and the driver should honor them.

The old driver works around this issue by treating a valid but slow
sync rate as the fastest rate.  This avoids this particular issue,
but prevents the user from setting such a slow rate should it be
needed.

--
Justin
