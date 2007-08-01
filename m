From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
 error
Date: Wed, 01 Aug 2007 15:54:53 +0200
Message-ID: <46B090AD.2070305@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:30038 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762778AbXHANzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 09:55:17 -0400
Received: by nf-out-0910.google.com with SMTP id g13so57210nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 06:55:16 -0700 (PDT)
In-Reply-To: <20070801133912.GA11027@kernel.sg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Eugene Teo wrote:
> Hi Gabriel,

Hi Eugene,
 
> Hope the following trivial patch helps.

Yes it does , thx.

> 
> <quote sender="Gabriel C">
>> Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )
>>
> [...]
>> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
>> drivers/scsi/advansys.c: In function 'advansys_board_found':
>> drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
> [...]
> 
> This patch fixes the following compile error:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function
> 'to_pci_dev'
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  drivers/scsi/advansys.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 79c0b6e..908f02b 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -774,6 +774,7 @@
>  #include <linux/stat.h>
>  #include <linux/spinlock.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/pci.h>
>  
>  #include <asm/io.h>
>  #include <asm/system.h>
> 
> 
