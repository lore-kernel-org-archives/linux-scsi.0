From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 3/3] faster workaround
Date: Tue, 23 Oct 2007 19:28:49 +0200
Message-ID: <200710231928.50207.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <470E3A35.4000104@garzik.org> <471DABE1.40301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <471DABE1.40301@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Soeren Sonnenburg <kernel@nn7.de>
List-Id: linux-scsi@vger.kernel.org

Hello Tejun,

On Tuesday 23 October 2007 10:08:01 Tejun Heo wrote:
> Jeff Garzik wrote:
> > Alan Cox wrote:
> >>> 2) Once we identified, over time, the set of drives affected by this
> >>> 3112 quirk (aka drives that didn't fully comply to SATA spec), the
> >>> debugging of corruption cases largely shifted to the standard
> >>> routine: update the BIOS, replace the
> >>> cables/RAM/power/mainboard/slot/etc. to be certain of problem location.
> >>
> >> Except for the continued series of later SI + Nvidia chipset (mostly)
> >> pattern which seems unanswered but also being later chips I assume
> >> unrelated to this problem.
> >
> > The SIL_FLAG_MOD15WRITE flag is set in sil_port_info[] is set according
> > to the best info we have from SiI, which indicates that 3114 and 3512 do
> > not have the same problem as the 3112.
>
> I don't think this data corruption problem w/ sil3114 is related to
> m15w.  m15w workaround slows down things quite a bit and is likely to
> hide problems on PCI bus side.  There are reports of data corruption
> with 3114 on nvidia (most common), via and now amd chipsets.  There's
> one on intel too but IIRC wasn't too definite.
>
> According to a user, freebsd didn't have data corruption problem on the
> same hardware.  I copied PCI FIFO setup code (ours is broken BTW) but it
> didn't fix the problem.
>
> I'll try to reproduce the problem locally and hunt it down.

thanks for your help and please tell me, if I can do anything. We have this 
problem on a production system, but the node in question will be rebooted in 
Thursday (ups needs to be replaced). If there are some tests/reboots/whatever 
I could do, it would be best to do it shortly after the scheduled reboot.

Actually I now would have attempted to port your mod15 patch 
(http://home-tj.org/wiki/index.php/Sil_m15w#Patches) to 2.6.23, hoping it 
would solve Soerens problem and ours as well (ours magically already went 
away using the mod15 fix). Well, maybe I port it anyway to 2.6.23 to see if 
it also solves our problem.


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
