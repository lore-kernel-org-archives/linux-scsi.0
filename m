From: Meelis Roos <mroos@linux.ee>
Subject: Re: EISA 53c825 - where to start?
Date: Tue, 16 Nov 2004 20:07:23 +0200 (EET)
Message-ID: <Pine.SOC.4.61.0411161923330.26610@math.ut.ee>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
 <1100618553.2770.16.camel@mulgrave> <Pine.SOC.4.61.0411161728190.26610@math.ut.ee>
 <wrp4qjplnpy.fsf@panther.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.5.125]:63920 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S262083AbUKPSHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 13:07:31 -0500
In-Reply-To: <wrp4qjplnpy.fsf@panther.wild-wind.fr.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Zyngier <mzyngier@freesurf.fr>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

> There is probably a converter chip somewhere near the 825 (look for a
> PLX chip with EISA written on it...)

No PLX but there is a Motorola chip near it with
SC02RH004DK08
142203-002

And another similar Motorola a bit further:
SC38SG003CN04
127053-002

Google finds both bot I see no realtion with neither pci nor eisa.

There is also a NCR 0390784 chip ner but this seems to be another scsi 
controller for cdrom and tape.

-- 
Meelis Roos (mroos@linux.ee)
