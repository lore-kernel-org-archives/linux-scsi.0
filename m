From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.12-rc4-mm1 3/4] megaraid_sas: updating the driver
Date: Mon, 16 May 2005 10:06:16 +0200
Message-ID: <1116230776.6274.20.camel@laptopd505.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCE7C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37286 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261416AbVEPIGU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 04:06:20 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CCE7C@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>

> +
> +		if (exception) {
> +	
> +			spin_lock( instance->host_lock );
> +			cmd->scmd->scsi_done( cmd->scmd );
> +			spin_unlock( instance->host_lock );

are you really sure you don't want to use spin_lock_irqsave() here ?

> +	unregister_chrdev( megasas_mgmt_majorno, "megaraid_sas_ioctl" );

I really don't like this idea of weird ioctl devices though...


