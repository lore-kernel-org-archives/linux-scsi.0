From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: EISA 53c825 - where to start?
Date: 16 Nov 2004 09:22:27 -0600
Message-ID: <1100618553.2770.16.camel@mulgrave>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42170 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262017AbUKPPWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 10:22:41 -0500
In-Reply-To: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 03:12, Meelis Roos wrote:
> I have a Compaq Proliant 4500 with onboard EISA-connected NCR 53c825 
> SCSI adapter. There is no EISA-aware version for this chip in Linux 
> AFAIK so I want to make one. EISA API is there, also several NCR/Sym/LSI 
> SCSI drivers. Which driver is the best to base the eisa work on? And 
> where should I start? :)

Are you sure it's an 825?  The reason I ask is because the 825 chip is
both a SCSI chip and a PCI chip with on-board BIOS.  The only real way I
could see it working as EISA is if it were glued to a EISA<->PCI
converter, which I didn't think existed.

Also, the only way to get this to work will be to find out what the
magic glue registers are and how they're mapped ... unless you have
access to the HW specs for the box, this is going to be tricky to
reverse engineer.

James


