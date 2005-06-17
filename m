From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid: regression fix
Date: Fri, 17 Jun 2005 12:20:54 +0100
Message-ID: <20050617112054.GC12178@infradead.org>
References: <1118853406.12918.17.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8607 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261951AbVFQLVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 07:21:03 -0400
Content-Disposition: inline
In-Reply-To: <1118853406.12918.17.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jun 15, 2005 at 09:36:46AM -0700, Mark Haverkamp wrote:
> -		kfib->header.XferState = 0;
> +		kfib->header.XferState = cpu_to_le32(0);

you never need to byte-swap the 0 constant.

