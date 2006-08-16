From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aacraid:  interruptible ioctl
Date: Wed, 16 Aug 2006 14:22:23 +0100
Message-ID: <20060816132223.GC16814@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02AC7454@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56279 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751056AbWHPNWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Aug 2006 09:22:43 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F02AC7454@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Aug 07, 2006 at 07:49:24AM -0400, Salyzyn, Mark wrote:
> We need to leak the fib, as it is still owned by the controller until
> the command has infact completed. The interrupt service completing the
> command, if it ever occurs, will cause the FIB to be returned to the
> pool.

Ok.

