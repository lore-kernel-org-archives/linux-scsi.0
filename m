From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 5/9] snic:add SCSI handling, AEN, and fwreset handling
Date: Mon, 11 May 2015 20:00:13 +0200
Message-ID: <5550EE2D.5030009@suse.de>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com> <1429694642-22309-6-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbbEKSAP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 14:00:15 -0400
In-Reply-To: <1429694642-22309-6-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/22/2015 11:23 AM, Narsimhulu Musini wrote:
> snic_scsi.c contains scsi handling, includes queuing io, abort, lun r=
eset,
> and host reset. Also it handles asynchronous event notifications from=
 FW.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
> * v5
> - Fixed host byte codes for the failed IOs.
>=20
> * v2
> - Changed queuecommand to lock-free version.
> - Converted custom error codes to standard error codes.
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
