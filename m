From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] snic:Add snic target discovery
Date: Mon, 02 Mar 2015 13:59:57 +0100
Message-ID: <54F45ECD.5010109@suse.de>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com> <1423586616-18177-5-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbbCBNAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 08:00:04 -0500
In-Reply-To: <1423586616-18177-5-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
> snic_disc.h contains snic target structure definition.
>=20
> snic_disc.c contains target discovery, setup, lookup, and cleanup
>=20
> snic_ctl.c contains retrieval of snic capabilities includes
> max ios, size, SGs per request, and max concurrent requests.
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
