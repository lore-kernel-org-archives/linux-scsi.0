From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 21 Aug 2006 13:24:10 -0600
Message-ID: <20060821192410.GD24068@parisc-linux.org>
References: <20060821104357.GH11651@stusta.de> <20060821105344.GA28759@infradead.org> <20060821192215.GL11651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35766 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750859AbWHUTYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:24:11 -0400
Content-Disposition: inline
In-Reply-To: <20060821192215.GL11651@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 21, 2006 at 09:22:15PM +0200, Adrian Bunk wrote:
> It sounds rather strange that non-arch code should use asm headers.

It should get everything it needs from including <linux/interrupt.h>
