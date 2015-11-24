From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] MAINTAINERS: Add myself as co-maintainer of the
 SCSI subsystem.
Date: Tue, 24 Nov 2015 13:44:06 +0100
Message-ID: <1448369046.2877.29.camel@suse.de>
References: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
	 <1447451209-30772-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbbKXMoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:44:08 -0500
In-Reply-To: <1447451209-30772-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, 2015-11-13 at 16:46 -0500, Martin K. Petersen wrote:
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
> =C2=A0MAINTAINERS | 4 +++-
> =C2=A01 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9de185da5f5b..978df6e36ddf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9205,8 +9205,10 @@ F:	include/scsi/sg.h
> =C2=A0
> =C2=A0SCSI SUBSYSTEM
> =C2=A0M:	"James E.J. Bottomley" <JBottomley@odin.com>
> -L:	linux-scsi@vger.kernel.org
> =C2=A0T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
> +M:	"Martin K. Petersen" <martin.petersen@oracle.com>
> +T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
> +L:	linux-scsi@vger.kernel.org
> =C2=A0S:	Maintained
> =C2=A0F:	drivers/scsi/
> =C2=A0F:	include/scsi/

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
