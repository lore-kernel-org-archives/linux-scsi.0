From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH] dma_get_required_mask()
Date: 28 Jun 2004 17:40:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088462407.2003.54.camel@mulgrave>
References: <1088457050.2004.40.camel@mulgrave>
	<20040628152839.23178136.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:13028 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265144AbUF1WkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 18:40:18 -0400
In-Reply-To: <20040628152839.23178136.davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2004-06-28 at 17:28, David S. Miller wrote:
> Maybe you should tweak the default implementation such that
> something reasonable happens on 64-bit platforms that
> define dma_addr_t as a 32-bit quantity. :-)

Actually, the default implementation should work on these platforms
too.  Since it's impossible to set a mask over 32 bits, then the best
dma_get_required_mask() will do is return a full spread of 32 bits,
since the memory mask is anded with the current dma mask.

James


