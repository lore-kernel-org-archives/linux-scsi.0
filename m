From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new
	module  for LSI Logic's SAS based MegaRAID controllers
Date: Mon, 07 Mar 2005 23:22:15 +0100
Message-ID: <1110234135.9233.73.camel@laptopd505.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230CC0E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:36796 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261798AbVCGWWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 17:22:24 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CC0E@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

On Mon, 2005-03-07 at 16:12 -0500, Bagalkote, Sreenivas wrote:

> +static	int				is_dma64;

the fact that this is a global variable worries me.



