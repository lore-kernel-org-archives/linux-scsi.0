From: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [PATCH 3/3] faster workaround
Date: Wed, 24 Oct 2007 15:39:28 +0200
Message-ID: <1193233168.5427.5.camel@localhost>
References: <200710081709.18253.bs@q-leap.de>
	 <200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>
	 <200710111433.23833.bs@q-leap.de>
	 <20071011142628.48272a4a@the-village.bc.nu>	<470E30F9.5060705@garzik.org>
	 <20071011155024.46007973@the-village.bc.nu> <470E3A35.4000104@garzik.org>
	 <471DABE1.40301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <471DABE1.40301@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernd Schubert <bs@q-leap.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-10-23 at 17:08 +0900, Tejun Heo wrote:
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

err wait, the motherboard I am having is also via based. however the
m15w workaround just slowed down everything but the problem still
appeared.

also to be sure that it is really some problem related to the particular
seagate drive vs. sil3114 I created a 200G file of zeros on one of the
known to work seagates. and indeed it was all zeros... 

> According to a user, freebsd didn't have data corruption problem on the
> same hardware.  I copied PCI FIFO setup code (ours is broken BTW) but it
> didn't fix the problem.
> 
> I'll try to reproduce the problem locally and hunt it down.

Thanks in advance...
Soeren
