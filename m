From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v5 3/3] cxlflash: Virtual LUN support
Date: Thu, 13 Aug 2015 22:03:22 +1000
Message-ID: <1439467402.21643.50.camel@neuling.org>
References: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbbHMMDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 08:03:24 -0400
In-Reply-To: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Wed, 2015-08-12 at 18:51 -0500, Matthew R. Ochs wrote:
> Add support for physical LUN segmentation (virtual LUNs) to device
> driver supporting the IBM CXL Flash adapter. This patch allows user
> space applications to virtually segment a physical LUN into N virtual
> LUNs, taking advantage of the translation features provided by this
> adapter.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Thanks for integrating my suggestions.  create_context() has the same
freeing bug as 2/3 but if you fix that I'm happy if you add my
reviewed by:

Reviewed-by: Michael Neuling <mikey@neuling.org>

> ---
>  Documentation/powerpc/cxlflash.txt |   63 +-
>  drivers/scsi/cxlflash/Makefile     |    2 +-
>  drivers/scsi/cxlflash/common.h     |    4 +
>  drivers/scsi/cxlflash/lunmgt.c     |    3 +
>  drivers/scsi/cxlflash/main.c       |   13 +
>  drivers/scsi/cxlflash/sislite.h    |   20 +-
>  drivers/scsi/cxlflash/superpipe.c  |   81 ++-
>  drivers/scsi/cxlflash/superpipe.h  |   17 +-
>  drivers/scsi/cxlflash/vlun.c       | 1243 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/vlun.h       |   86 +++
>  include/uapi/scsi/cxlflash_ioctl.h |   34 +
>  11 files changed, 1549 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/scsi/cxlflash/vlun.c
>  create mode 100644 drivers/scsi/cxlflash/vlun.h

