From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_scan: fix queue depth initialisation problem
Date: Wed, 29 Apr 2015 08:48:46 +0200
Message-ID: <55407ECE.3020502@suse.de>
References: <1430256250.2181.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbbD2Gss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 02:48:48 -0400
In-Reply-To: <1430256250.2181.17.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 04/28/2015 11:24 PM, James Bottomley wrote:
> From: James Bottomley <JBottomley@Odin.com>
> Date: Sun, 26 Apr 2015 11:52:46 -0700
> Subject: [PATCH] scsi_scan: fix queue depth initialisation problem
>=20
> Currently we blindly use the value of cmd_per_lun as the initial sett=
ing for
> queue_depth.  This fails miserably (hangs the system) if it is zero, =
which is
> the default value for anything uninitialised in the template.  The ne=
t result
> is that every host template has to set a value for cmd_per_lun.  Inst=
ead, use
> a default value of 1 if the actual value is unset.  This should pave =
the way
> for removing cmd_per_lun from all the templates and eventually from S=
CSI
> itself.
>=20
> Signed-off-by: James Bottomley <JBottomley@Odin.com>
Tested-by: Hannes Reinecke <hare@suse.de>

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
