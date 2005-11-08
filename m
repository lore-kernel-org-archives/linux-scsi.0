From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] remove the obsolete SCSI qlogicisp driver
Date: Tue, 8 Nov 2005 19:13:10 +0000
Message-ID: <20051108191310.GA23922@infradead.org>
References: <20051108182527.GC3847@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54973 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965270AbVKHTNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Nov 2005 14:13:20 -0500
Content-Disposition: inline
In-Reply-To: <20051108182527.GC3847@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 08, 2005 at 07:25:27PM +0100, Adrian Bunk wrote:
> The SCSI qlogicisp driver is both marked BROKEN and superseded by the 
> qla1280 driver.

It's already gone in the scsi-misc tree.

