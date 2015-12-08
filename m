From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/20] qla2xxx: Enable Target counters in DebugFS.
Date: Tue, 8 Dec 2015 16:52:42 +0100
Message-ID: <5666FCCA.4060501@suse.de>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-4-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbbLHPwo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 10:52:44 -0500
In-Reply-To: <1449535747-2850-4-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/08/2015 01:48 AM, Himanshu Madhani wrote:
> Following counters are added in target mode to help debugging efforts=
=2E
>=20
> Target Counters
>=20
> qla_core_sbt_cmd =3D 0
> qla_core_ret_sta_ctio =3D 0
> qla_core_ret_ctio =3D 0
> core_qla_que_buf =3D 0
> core_qla_snd_status =3D 0
> core_qla_free_cmd =3D 0
> num alloc iocb failed =3D 0
> num term exchange sent =3D 0
> num Q full sent =3D 0
>=20
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
