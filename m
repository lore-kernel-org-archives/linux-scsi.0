From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE][PATCH 2.6.11 1/3] megaraid_sas: Announcing new
	module  for LSI Logic's SAS based MegaRAID controllers
Date: Mon, 07 Mar 2005 22:54:48 +0100
Message-ID: <1110232488.9233.69.camel@laptopd505.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230CC0D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:57531 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261851AbVCGVzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 16:55:02 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CC0D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

On Mon, 2005-03-07 at 16:09 -0500, Bagalkote, Sreenivas wrote:
> Hello All,
> 
> We are announcing a driver for LSI Logic's new SAS based MegaRAID 
> controllers. I am submitting the inlined patch in three parts. Please
> review the patches.
> 

>  source "drivers/scsi/megaraid/Kconfig.megaraid"
> +source "drivers/scsi/megaraid/Kconfig.megaraid_sas"
>  

why a fully separate file and not add your ONE config option to
Kconfig.megaraid instead ??


