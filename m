From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/6] fnic: Patch MAINTAINERS, scsi Makefile, scsi
 Kconfig
Date: Thu, 25 Jun 2009 12:00:35 -0500
Message-ID: <1245949235.4170.63.camel@mulgrave.site>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
	 <20090418013322.24787.53673.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41409 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbZFYRAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2009 13:00:36 -0400
In-Reply-To: <20090418013322.24787.53673.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: linux-scsi@vger.kernel.org, jeykholt@cisco.com

On Fri, 2009-04-17 at 18:33 -0700, Abhijeet Joglekar wrote:
> Patch MAINTAINERS file, add fnic module to scsi Makefile and Kconfig
> 
> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
> Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  MAINTAINERS           |    8 ++++++++
>  drivers/scsi/Kconfig  |   11 +++++++++++
>  drivers/scsi/Makefile |    1 +
>  3 files changed, 20 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebaf77e..405f574 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1167,6 +1167,14 @@ P:	Nils Faerber (port to kernel 2.4)
>  M:	Nils Faerber <nils@kernelconcepts.de>
>  S:	Maintained
>  
> +CISCO FCOE HBA DRIVER
> +P:	Abhijeet Joglekar
> +M:	abjoglek@cisco.com
> +P:	Joe Eykholt
> +M:	jeykholt@cisco.com
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +
>  CODA FILE SYSTEM
>  P:	Jan Harkes
>  M:	jaharkes@cs.cmu.edu
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 876cd20..d45f3ad 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -628,6 +628,17 @@ config FCOE
>  	---help---
>  	  Fibre Channel over Ethernet module
>  
> +config FCOE_FNIC
> +	tristate "Cisco FNIC Driver"
> +	depends on PCI && X86

Why is this marked X86 only?  Surely as a PCIe card it should work on
any architecture?

James


