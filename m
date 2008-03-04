From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
 into using pci_get device
Date: Tue, 04 Mar 2008 08:48:28 +0100
Message-ID: <47CCFECC.8040709@suse.de>
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com> <20080216163756.GG7657@parisc-linux.org> <47B80E65.7090504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:47737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYCDHsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 02:48:31 -0500
In-Reply-To: <47B80E65.7090504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, Sergio Luis <sergio@larces.uece.br>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Boaz Harrosh wrote:
> On Sat, Feb 16 2008 at 18:37 +0200, Matthew Wilcox <matthew@wil.cx> w=
rote:
>> On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
>>> I still don't have a card for testing myself. Again anyone
>>> wants to send me a card. Intel people anybody home?
>> Apparently Intel sold this line of cards to Adaptec.  The copyright
>> notice in the file backs this up:
>>
>>  * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner             =
    *
>>  * Copyright (C) 2002-04 Intel Corporation                          =
    *
>>  * Copyright (C) 2003-06 Adaptec Inc.                               =
    *
>>  * <achim_leubner@adaptec.com>                                      =
    *
>>
>=20
> OK I never got this guy to ping back. CCing support@adaptec.com.
>=20
> Who is the right contact person, regarding the HW that is supported
> by the gdth driver? Form what we see in driver commit logs (above),=20
> it was transfered to  Adaptec from Intel in 2003. Is that still so?
>=20
Yes, apparently. But gdth is the driver for the rather old ICP Vortex
range; most of which are driven by aacraid nowadays.
I thought I had one of these beasts; will check.

But yes, this is Adaptec. Unless the person is Mark Salyzyn or Luben
it's quite tricky to excite any response.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
