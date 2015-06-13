From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6] cxlflash: Base support for IBM CXL Flash Adapter
Date: Sat, 13 Jun 2015 08:59:47 -0700
Message-ID: <1434211187.2208.2.camel@HansenPartnership.com>
References: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35300 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbbFMP7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2015 11:59:49 -0400
In-Reply-To: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Tue, 2015-06-09 at 17:15 -0500, Matthew R. Ochs wrote:
> SCSI device driver to support filesystem access on the IBM CXL Flash adapter.
> 
> Supported-by: Stephen Bates <stephen.bates@pmcs.com>
> Reviewed-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---
>  drivers/scsi/Kconfig            |    1 +
>  drivers/scsi/Makefile           |    1 +
>  drivers/scsi/cxlflash/Kconfig   |   11 +
>  drivers/scsi/cxlflash/Makefile  |    2 +
>  drivers/scsi/cxlflash/common.h  |  181 +++
>  drivers/scsi/cxlflash/main.c    | 2294 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/main.h    |  104 ++
>  drivers/scsi/cxlflash/sislite.h |  465 ++++++++
>  8 files changed, 3059 insertions(+)
>  create mode 100644 drivers/scsi/cxlflash/Kconfig
>  create mode 100644 drivers/scsi/cxlflash/Makefile
>  create mode 100644 drivers/scsi/cxlflash/common.h
>  create mode 100644 drivers/scsi/cxlflash/main.c
>  create mode 100644 drivers/scsi/cxlflash/main.h
>  create mode 100755 drivers/scsi/cxlflash/sislite.h

That last one shows execute permission on a header file, which is a big
no-no.  checkpatch would have given you an error for this ... please use
it next time.  I fixed this up when applying.

James


