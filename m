From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 07/17] scsi: aic79xx_core fix shadowed variables, add
 statics
Date: Tue, 14 Oct 2008 09:39:16 +0200
Message-ID: <48F44CA4.7000502@suse.de>
References: <200809222156.m8MLukig032282@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:57528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYJNHjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 03:39:18 -0400
In-Reply-To: <200809222156.m8MLukig032282@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

Hi Andrew,

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
>=20
> Redeclared within different if/else blocks, safe to reuse the
> original from beginning of function.
> drivers/scsi/aic7xxx/aic79xx_core.c:2475:10: warning: symbol 'scbid' =
shadows an earlier one
> drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
> drivers/scsi/aic7xxx/aic79xx_core.c:2586:10: warning: symbol 'scbid' =
shadows an earlier one
> drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
> drivers/scsi/aic7xxx/aic79xx_core.c:2587:15: warning: symbol 'scb' sh=
adows an earlier one
> drivers/scsi/aic7xxx/aic79xx_core.c:2393:13: originally declared here
>=20
> Use caminfo for the outer declaration, the redeclared version is
> iterating over all initiator/target pairs (devices) which.
> drivers/scsi/aic7xxx/aic79xx_core.c:8857:23: warning: symbol 'devinfo=
' shadows an earlier one
> drivers/scsi/aic7xxx/aic79xx_core.c:8711:21: originally declared here
>=20
> Forward declaration was already marked static, make the definition ma=
tch.
> drivers/scsi/aic7xxx/aic79xx_core.c:3693:1: warning: symbol 'ahd_devl=
imited_syncrate' was not declared. Should it be static?
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
