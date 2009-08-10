From: Hannes Reinecke <hare@suse.de>
Subject: Re: question about drivers/scsi/aic7xxx/aic79xx_pci.c
Date: Mon, 10 Aug 2009 13:10:41 +0200
Message-ID: <4A800031.5060808@suse.de>
References: <Pine.LNX.4.64.0907291907190.22045@ask.diku.dk> <1248888420.3900.82.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53073 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbZHJLKl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 07:10:41 -0400
In-Reply-To: <1248888420.3900.82.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-07-29 at 19:09 +0200, Julia Lawall wrote:
>> In the file drivers/scsi/aic7xxx/aic79xx_pci.c, the function=20
>> ahd_aic790X_setup contains the code:
>>
>>                 ahd->features |=3D AHD_RTI|AHD_NEW_IOCELL_OPTS
>>                               |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_D=
ELIVERY
>>                               |  AHD_BUSFREEREV_BUG;
>>                 ahd->bugs |=3D AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;
>>
>> Should AHD_BUSFREEREV_BUG be moved from ahd->features to ahd->bugs?
>=20
> In theory, yes.  In practice, it's harmless in features since the val=
ue
> is above any feature flag.  The question is whether the B rev boards
> actually might work better (or worse) with this, since they've been
> operating without it for decades ... do we have any to test?
>=20
I have some. If you can tell me how to detect them I'll have a look.

Cheers,

Hannes
---
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
