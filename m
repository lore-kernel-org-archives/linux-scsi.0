From: "David S. Miller" <davem@redhat.com>
Subject: Re: PATCH] dma_get_required_mask()
Date: Mon, 28 Jun 2004 15:39:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628153941.1317d9bf.davem@redhat.com>
References: <1088457050.2004.40.camel@mulgrave>
	<20040628152839.23178136.davem@redhat.com>
	<1088462407.2003.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:15014 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265270AbUF1WlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 18:41:12 -0400
In-Reply-To: <1088462407.2003.54.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 28 Jun 2004 17:40:06 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2004-06-28 at 17:28, David S. Miller wrote:
> > Maybe you should tweak the default implementation such that
> > something reasonable happens on 64-bit platforms that
> > define dma_addr_t as a 32-bit quantity. :-)
> 
> Actually, the default implementation should work on these platforms
> too.  Since it's impossible to set a mask over 32 bits, then the best
> dma_get_required_mask() will do is return a full spread of 32 bits,
> since the memory mask is anded with the current dma mask.

Perfect, I didn't notice that.
