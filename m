From: Christoph Hellwig <hch@lst.de>
Subject: Re: [-mm patch] drivers/scsi/gdth.c: make __gdth_execute() static
Date: Fri, 10 Feb 2006 14:11:11 +0100
Message-ID: <20060210131111.GB9733@lst.de>
References: <20060207220627.345107c3.akpm@osdl.org> <20060210003737.GH3524@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41960 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932075AbWBJNLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 08:11:23 -0500
Content-Disposition: inline
In-Reply-To: <20060210003737.GH3524@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, achim_leubner@adaptec.com, linux-scsi@vger.kernel.org

On Fri, Feb 10, 2006 at 01:37:37AM +0100, Adrian Bunk wrote:
> I don't see any reason for __gdth_execute() being global.

Thanks, I've updated my patch locally and once I've gotten positive
testing feedback I'll send along the updated variant.

