From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 1/9] snic: snic module infrastructure
Date: Thu, 09 Apr 2015 14:40:04 +0200
Message-ID: <55267324.3090102@suse.de>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com> <1428580189-22785-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbbDIMkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 08:40:07 -0400
In-Reply-To: <1428580189-22785-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
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
