From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/9] snic: snic module infrastructure
Date: Wed, 25 Mar 2015 11:05:44 +0100
Message-ID: <55128878.80404@suse.de>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbbCYKFq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2015 06:05:46 -0400
In-Reply-To: <1426093299-4511-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
> snic_main.c contains module load and unload, global driver context,
> PCI Registration, PCI probe and remove, SCSI ML registration function=
ality.
>=20
> snic.h contains snic structure definition, snic global context, and
> prototypes.
>=20
> snic_os.h contains OS specific interfaces.
>=20
> snic_attrs.c contains device attributes to list snic state, link stat=
e,
> and driver version under /sys/class/scsi_host/host<id>/
>=20
> v2
> Added Compile time macro for debugfs dependent functionality.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
