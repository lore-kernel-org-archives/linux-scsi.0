From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] target: Drop se_lun->lun_active for existing percpu
 lun_ref
Date: Fri, 22 May 2015 09:58:58 +0200
Message-ID: <555EE1C2.6060601@suse.de>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com> <1432278417-29994-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbbEVH67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 03:58:59 -0400
In-Reply-To: <1432278417-29994-4-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

On 05/22/2015 09:06 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> With se_port_t and t10_alua_tg_pt_gp_member being absored into se_lun=
,
> there is no need for an extra atomic_t based reference count for PR
> ALL_TG_PT=3D1 and ALUA access state transition.
>=20
> Go ahead and use the existing percpu se_lun->lun_ref instead, and
> convert the two special cases to percpu_ref_tryget_live() to avoid
> se_lun if transport_clear_lun_ref() has already been invoked to
> shutdown the se_lun.
>=20
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
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
