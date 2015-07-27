From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 7/8] qla2xxx: drop cmds/tmrs arrived while session
 is being deleted
Date: Mon, 27 Jul 2015 10:17:36 +0200
Message-ID: <55B5E920.5030200@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-8-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436904049-27707-8-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> If a new initiator (different WWN) shows up on the same fcport, old
> initiator's session is scheduled for deletion. But there is a small
> window between it being marked with QLA_SESS_DELETION_IN_PROGRESS
> and qlt_unret_sess getting called when new session's commands will
> keep finding old session in the fcport map.
>=20
> This patch drops cmds/tmrs if they find session in the progress of
> being deleted.
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
