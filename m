From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/8] qla2xxx: Abort stale cmds on qla_tgt_wq when plogi
 arrives
Date: Mon, 27 Jul 2015 10:14:34 +0200
Message-ID: <55B5E86A.5030402@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-5-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbbG0IOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 04:14:36 -0400
In-Reply-To: <1436904049-27707-5-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> cancel any commands from initiator's s_id that are still waiting
> on qla_tgt_wq when PLOGI arrives.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Acked-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
