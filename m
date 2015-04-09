From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 2/9] snic:Add interrupt, resource firmware interfaces
Date: Thu, 09 Apr 2015 14:46:36 +0200
Message-ID: <552674AC.10802@suse.de>
References: <1428580189-22785-1-git-send-email-nmusini@cisco.com> <1428580189-22785-3-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbbDIMqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2015 08:46:38 -0400
In-Reply-To: <1428580189-22785-3-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/09/2015 01:49 PM, Narsimhulu Musini wrote:
> snic_fwint.h contains firmware interface structures.
>=20
> snic_res.h contains firmware request initialization
>=20
> snic_res.c contains retrieval of resource configuration, and allocati=
on,
> and initialization of HW Queues.
>=20
> snic_isr.c contains interrupt request, release, and handling
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
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
