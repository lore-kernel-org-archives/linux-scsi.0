From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 15/17] smartpqi: update maintainers
Date: Mon, 29 Aug 2016 11:42:25 +0200
Message-ID: <20160829094225.xlrpzjto22ushvn7@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222993662.31214.1739657681215763725.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756125AbcH2Jm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 05:42:28 -0400
Content-Disposition: inline
In-Reply-To: <147222993662.31214.1739657681215763725.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Fri, Aug 26, 2016 at 11:45:36AM -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
> 
> added Documentation/scsi/smartpqi.txt
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f50fe50..d980685 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5447,6 +5447,7 @@ F:	drivers/scsi/smartpqi/Kconfig
>  F:	drivers/scsi/smartpqi/Makefile
>  F:	include/linux/cciss*.h
>  F:	include/uapi/linux/cciss*.h
> +F:	Documentation/scsi/smartpqi.txt

This should be foldet into the next patch where you actually add the
documentation ;-).

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
