From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: EISA 53c825 - where to start?
Date: Tue, 16 Nov 2004 18:15:21 +0100
Message-ID: <wrp4qjplnpy.fsf@panther.wild-wind.fr.eu.org>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
	<1100618553.2770.16.camel@mulgrave>
	<Pine.SOC.4.61.0411161728190.26610@math.ut.ee>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53636 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S262060AbUKPRPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 12:15:31 -0500
In-Reply-To: <Pine.SOC.4.61.0411161728190.26610@math.ut.ee> (Meelis Roos's
 message of "Tue, 16 Nov 2004 18:33:55 +0200 (EET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

>>>>> "Meelis" == Meelis Roos <mroos@linux.ee> writes:

>> Are you sure it's an 825?  The reason I ask is because the 825 chip is
>> both a SCSI chip and a PCI chip with on-board BIOS.  The only real way I
>> could see it working as EISA is if it were glued to a EISA<->PCI
>> converter, which I didn't think existed.

Meelis> Well, the chip has
Meelis> NCR
Meelis> 53C825

There is probably a converter chip somewhere near the 825 (look for a
PLX chip with EISA written on it...)

	M.
-- 
And if you don't know where you're going, any road will take you there...
