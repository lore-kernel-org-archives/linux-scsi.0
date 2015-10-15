From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH  1/2] qla2xxx: Remove unavailable firmware files
Date: Thu, 15 Oct 2015 09:45:12 +0200
Message-ID: <561F5988.3070604@suse.de>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com> <1444838261-20990-2-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbbJOHpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Oct 2015 03:45:14 -0400
In-Reply-To: <1444838261-20990-2-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 10/14/2015 05:57 PM, Himanshu Madhani wrote:
> Remove firmware binary names for the ISPs, which
> are not submitted to linux-firmware
>=20
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |   29 -----------------------------
>  1 files changed, 0 insertions(+), 29 deletions(-)
>=20
Thank you. This has cause quite some confusion with some customers.

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
