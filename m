From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Thu, 02 Apr 2009 08:36:01 -0500
Message-ID: <1238679361.3383.4.camel@mulgrave.int.hansenpartnership.com>
References: <200904020335.n323ZJVh004287@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37466 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbZDBNgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 09:36:05 -0400
In-Reply-To: <200904020335.n323ZJVh004287@blc-10-2.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com, vravindr@brocade.com

On Wed, 2009-04-01 at 20:35 -0700, Krishna Gudipati wrote:
> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
> 
> This patch contains Makefile and Kconfig file for scsi and bfa.Fixed
> the code review comments from previous submission.
> 
> Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
> ---
>  Kconfig      |    9 +++++++++
>  Makefile     |    1 +
>  bfa/Makefile |   27 +++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
> 
> diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
> --- orig/drivers/scsi/Kconfig	2009-04-01 20:08:49.271161000 -0700
> +++ patch/drivers/scsi/Kconfig	2009-04-01 20:08:44.003822000 -0700
> @@ -1797,6 +1797,15 @@ config SCSI_SRP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called libsrp.
>  
> +config SCSI_BFA_FC
> +	tristate "Brocade BFA Fibre Channel Support"
> +	depends on PCI && SCSI
> +	help
> +	  This bfa driver supports all Brocade PCIe Fibre Channel host adapters.
> +
> +	  To compile this driver as a module, choose M here. The module will
> +	  be called bfa.
> +

You're still not using the FC transport class to export common sysfs FC
information or to help make your driver smaller.  I thought you were
going to fix this after this was noted in your first submission to
linux-scsi on 24 September?

James


