From: Meelis Roos <mroos@linux.ee>
Subject: Re: EISA 53c825 - where to start?
Date: Tue, 16 Nov 2004 18:33:55 +0200 (EET)
Message-ID: <Pine.SOC.4.61.0411161728190.26610@math.ut.ee>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
 <1100618553.2770.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.5.125]:48323 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S262033AbUKPQeA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 11:34:00 -0500
In-Reply-To: <1100618553.2770.16.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

> Are you sure it's an 825?  The reason I ask is because the 825 chip is
> both a SCSI chip and a PCI chip with on-board BIOS.  The only real way I
> could see it working as EISA is if it were glued to a EISA<->PCI
> converter, which I didn't think existed.

Well, the chip has
NCR
53C825
609-0391625
DP03537
9515N
written on it.

> Also, the only way to get this to work will be to find out what the
> magic glue registers are and how they're mapped ... unless you have
> access to the HW specs for the box, this is going to be tricky to
> reverse engineer.

Hmm. At least Windows and Solaris drivers should work, should be able to 
at least disassmble them if there is no other way - if I ever get that 
far.

A quick glance at NetBSD and FreeBSD didn't reveal a EISA version of the 
driver either :(

-- 
Meelis Roos (mroos@linux.ee)
