From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 1/9] snic: snic module infrastructure
Date: Mon, 11 May 2015 19:55:03 +0200
Message-ID: <5550ECF7.1020408@suse.de>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com> <1429694642-22309-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbbEKRzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 13:55:05 -0400
In-Reply-To: <1429694642-22309-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/22/2015 11:23 AM, Narsimhulu Musini wrote:
> snic_main.c contains module load and unload, global driver context,
> PCI Registration, PCI probe and remove, SCSI ML registration function=
ality.
>=20
> snic.h contains snic structure definition, snic global context, and
> prototypes.
>=20
> snic_attrs.c contains device attributes to list snic state, link stat=
e,
> and driver version under /sys/class/scsi_host/host<id>/
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
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
