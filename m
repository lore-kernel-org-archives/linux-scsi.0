From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] qla2xxx: Add ISP82XX support.
Date: Sun, 07 Mar 2010 13:36:09 +0530
Message-ID: <1267949169.2812.41.camel@mulgrave.site>
References: <1267740777-3862-1-git-send-email-giridhar.malavali@qlogic.com>
	 <1267740777-3862-2-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0CGIGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Mar 2010 03:06:19 -0500
In-Reply-To: <1267740777-3862-2-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2010-03-04 at 14:12 -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> Enhanced the driver to support new FCoE board.
> 
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/Makefile     |    2 +-
>  drivers/scsi/qla2xxx/qla_attr.c   |   12 +-
>  drivers/scsi/qla2xxx/qla_dbg.c    |    3 +
>  drivers/scsi/qla2xxx/qla_def.h    |   51 +-
>  drivers/scsi/qla2xxx/qla_gbl.h    |   80 +
>  drivers/scsi/qla2xxx/qla_gs.c     |    2 +-
>  drivers/scsi/qla2xxx/qla_init.c   |  217 ++-
>  drivers/scsi/qla2xxx/qla_inline.h |    5 +-
>  drivers/scsi/qla2xxx/qla_iocb.c   |   70 +-
>  drivers/scsi/qla2xxx/qla_isr.c    |   38 +-
>  drivers/scsi/qla2xxx/qla_mbx.c    |  136 ++-
>  drivers/scsi/qla2xxx/qla_nx.c     | 3496
> +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_nx.h     |  807 +++++++++
>  drivers/scsi/qla2xxx/qla_os.c     |  254 +++-
>  drivers/scsi/qla2xxx/qla_sup.c    |   80 +-
>  15 files changed, 5134 insertions(+), 119 deletions(-)
>  create mode 100644 drivers/scsi/qla2xxx/qla_nx.c
>  create mode 100644 drivers/scsi/qla2xxx/qla_nx.h

checkpatch.pl isn't very happy with this:

total: 149 errors, 137 warnings, 6076 lines checked

Can you at least fix the errors, which are mostly whitespace and spaces
instead of tabs problems? (I'm not bothered much about the warnings,
since that's more a style matter for driver writers).

Thanks,

James


