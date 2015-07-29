From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/8] pm80xx: Corrected device state changes in I_T_Nexus_Reset
Date: Wed, 29 Jul 2015 10:53:43 +0200
Message-ID: <55B89497.3070502@suse.de>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com> <1438151240-4097-3-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbG2Ixo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 04:53:44 -0400
In-Reply-To: <1438151240-4097-3-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com

On 07/29/2015 08:27 AM, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
>=20
> In Nexus reset the device state set to DS_IN_RECOVERY before doing
> phy reset and internal cleanup. Once internal cleanup finishes,
> the device state will set to DS_OPERATIONAL.
>=20
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>=20
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
