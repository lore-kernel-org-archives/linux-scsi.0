From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] scsi_dh_alua: Retry the check-condition in
 case	Mode Parameters Changed
Date: Mon, 09 Jan 2012 08:12:13 +0100
Message-ID: <4F0A934D.6000802@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD910D14606@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2AIHMO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2012 02:12:14 -0500
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD910D14606@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, linux-scsi@vger.kernel.org, JBottomley@Parallels.com

On 12/22/2011 12:01 AM, Moger, Babu wrote:
> This patch adds a check-condition in scsi_dh_alua handler for a retry=
=2E
> Sometimes,
> I have seen attach failing due to this check-condition with following
> error=20
> messages on NetApp E series storage.
>=20
> Dec  7 15:31:01 nilgiris kernel: [102979.696673] scsi 3:0:2:9: alua:
> port group 00 rel port 01
> Dec  7 15:31:01 nilgiris kernel: [102979.697082] scsi 3:0:2:9: alua:
> rtpg failed with 8000002
> Dec  7 15:31:01 nilgiris kernel: [102979.697086] scsi 3:0:2:9: alua:
> rtpg sense code 06/2a/01
> Dec  7 15:31:01 nilgiris kernel: [102979.697088] scsi 3:0:2:9: alua: =
not
> attached
>=20
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
Looks ok.

Acked-by: Hannes Reinecke <hare@suse.de>

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
