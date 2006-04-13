From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: HBA self selection
Date: Thu, 13 Apr 2006 16:01:36 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044C02@cceexc17.americas.cpqcorp.net>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net><20060413152419.GD24104@parisc-linux.org><1144950427.3474.39.camel@mulgrave.il.steeleye.com><5CCF5F0F2514664CBE20FD24BCE17614044BFD@cceexc17.americas.cpqcorp.net> <1144958819.3474.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:32938 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S932466AbWDMVBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2006 17:01:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

James Bottomley wrote:

> Erm, as I read the MSA30 documentation, it has fourteen drive bays.
> That means it has 14 targets plus the processor, so since 16 is the
> addressing capacity of a wide SPI bus, there doesn't seem to be a need
> to have the initiator and the processor at the same ID ... what's the
> reason they have to be?

Probably for the same reason one cuts the end of a pot roast 
off before cooking it.  Because mom did it that way, who did it 
that way because grandma did it that way, and turns out grandma 
did it that way only because her pan wasn't big enough.

MSA30's grandma was an old narrow scsi Proliant jbod that only had
8 IDs to work with -- pan not big enough.  I'm just guessing though.

It is what it is.

-- steve









