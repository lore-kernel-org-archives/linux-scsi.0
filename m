From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/8] qla2xxx: added sess generations to detect RSCN
 update races
Date: Mon, 27 Jul 2015 10:16:12 +0200
Message-ID: <55B5E8CC.9030107@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-6-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbbG0IQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 04:16:15 -0400
In-Reply-To: <1436904049-27707-6-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Alexei Potashnik <alexei@purestorage.com>
>=20
> RSCN processing in qla2xxx driver can run in parallel with ELS/IO
> processing. As such the decision to remove disappeared fc port's
> session could be stale, because a new login sequence has occurred
> since and created a brand new session.
>=20
> Previous mechanism of dealing with this by delaying deletion request
> was prone to erroneous deletions if the event that was supposed to
> cancel the deletion never arrived or has been delayed in processing.
>=20
> New mechanism relies on a time-like generation counter to serialize
> RSCN updates relative to ELS/IO updates.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
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
