From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 4/9] snic:Add snic target discovery
Date: Mon, 11 May 2015 19:58:04 +0200
Message-ID: <5550EDAC.8040108@suse.de>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com> <1429694642-22309-5-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbbEKR6G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 13:58:06 -0400
In-Reply-To: <1429694642-22309-5-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 04/22/2015 11:23 AM, Narsimhulu Musini wrote:
> snic_disc.h contains snic target structure definition.
>=20
> snic_disc.c contains target discovery, setup, lookup, and cleanup
>=20
> snic_ctl.c contains retrieval of snic capabilities includes
> max ios, size, SGs per request, and max concurrent requests.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
deviceloss handling should really be moved to a generic
infrastructure, but that is a topic for a different
patchset.

So:

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
