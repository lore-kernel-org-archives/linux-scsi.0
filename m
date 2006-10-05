From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI st: fix error handling in module init, sysfs
Date: Thu, 5 Oct 2006 23:07:52 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0610052305460.7808@kai.makisara.local>
References: <20061004100037.GA16915@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:24159 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751145AbWJEUIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Oct 2006 16:08:04 -0400
In-Reply-To: <20061004100037.GA16915@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 4 Oct 2006, Jeff Garzik wrote:

> 
> - Notice and handle sysfs errors in module init, tape init
> 
> - Properly unwind errors in module init
> 
> - Remove bogus st_sysfs_class==NULL test, it is guaranteed !NULL at that point
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 

Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

> ---
> 
>  drivers/scsi/st.c |  115 ++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 78 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 7f669b6..3babdc7 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -195,9 +195,9 @@ static int sgl_unmap_user_pages(struct s
>  static int st_probe(struct device *);
...

Thanks,
Kai
