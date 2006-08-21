From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 21 Aug 2006 11:53:44 +0100
Message-ID: <20060821105344.GA28759@infradead.org>
References: <20060821104357.GH11651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23193 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751850AbWHUKyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 06:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20060821104357.GH11651@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 21, 2006 at 12:43:57PM +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - #include <linux/irq.h> for getting the prototypes of
>   {dis,en}able_irq()

nothing outside of arch code must ever include <linux/irq.h>

