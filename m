From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 2.6: Support for new cards
Date: Thu, 16 Dec 2004 17:03:59 +0000
Message-ID: <20041216170359.GA10761@infradead.org>
References: <1103063344.15699.27.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:32702 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261946AbULPREE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 12:04:04 -0500
Content-Disposition: inline
In-Reply-To: <1103063344.15699.27.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> +/*
> + * This adapter is a slave (no Firmware)
> + */
> +#define AAC_QUIRK_SLAVE 0x0004

This is set once but never cleared.

> +/*
> + * This adapter is a master.
> + */
> +#define AAC_QUIRK_MASTER 0x0008

And this one is completely unused.

