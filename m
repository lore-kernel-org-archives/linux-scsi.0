From: "David S. Miller" <davem@redhat.com>
Subject: Re: PATCH] dma_get_required_mask()
Date: Mon, 28 Jun 2004 15:28:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628152839.23178136.davem@redhat.com>
References: <1088457050.2004.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36768 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262085AbUF1WaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 18:30:10 -0400
In-Reply-To: <1088457050.2004.40.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 28 Jun 2004 16:10:43 -0500
James Bottomley <James.Bottomley@steeleye.com> wrote:

> This patch implements dma_get_required_mask() which may be used by
> drivers to probe the optimal DMA descriptor type they should be
> implementing on the platform.

Maybe you should tweak the default implementation such that
something reasonable happens on 64-bit platforms that
define dma_addr_t as a 32-bit quantity. :-)

Of course, you've provided ARCH_HAS_DMA_GET_REQUIRED_MASK
in order to deal with these cases, so it's not mandatory.
