From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: EISA 53c825 - where to start?
Date: 16 Nov 2004 12:20:51 -0600
Message-ID: <1100629257.2770.48.camel@mulgrave>
References: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
	<1100618553.2770.16.camel@mulgrave>
	<Pine.SOC.4.61.0411161728190.26610@math.ut.ee>
	<wrp4qjplnpy.fsf@panther.wild-wind.fr.eu.org>
	<Pine.SOC.4.61.0411161923330.26610@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50393 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262087AbUKPSVE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 13:21:04 -0500
In-Reply-To: <Pine.SOC.4.61.0411161923330.26610@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Marc Zyngier <mzyngier@freesurf.fr>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 12:07, Meelis Roos wrote:
> No PLX but there is a Motorola chip near it with
> SC02RH004DK08
> 142203-002
> 
> And another similar Motorola a bit further:
> SC38SG003CN04
> 127053-002
> 
> Google finds both bot I see no realtion with neither pci nor eisa.
> 
> There is also a NCR 0390784 chip ner but this seems to be another scsi 
> controller for cdrom and tape.

Well, the good news is that if you can find this chip and its
documentation then you can simply construct it as an EISA<->PCI bridge
and then the sym_2 driver should work with the 825 chip without
modification.  The Bad news, of course, is that you have to find the
chip and its documentation...

James


