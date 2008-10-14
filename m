From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 08/17] scsi: aic79xx aic79xx_pci.c fix shadowed variables
Date: Tue, 14 Oct 2008 09:39:57 +0200
Message-ID: <48F44CCD.4020807@suse.de>
References: <200809222156.m8MLukEN032285@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbYJNHj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 03:39:58 -0400
In-Reply-To: <200809222156.m8MLukEN032285@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

Hi Andrew,

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
>=20
> OK to just reuse the outer declaration as it is never used again.
> drivers/scsi/aic7xxx/aic79xx_pci.c:340:12: warning: symbol 'devconfig=
' shadows an earlier one
> drivers/scsi/aic7xxx/aic79xx_pci.c:299:12: originally declared here
>=20
> targpcistat is always assigned just before use, remove the inner decl=
aration.
> drivers/scsi/aic7xxx/aic79xx_pci.c:486:9: warning: symbol 'targpcista=
t' shadows an earlier one
> drivers/scsi/aic7xxx/aic79xx_pci.c:429:9: originally declared here
>=20
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hannes Reinecke <hare@suse.de>

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
