From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] small sym2 sparse fix
Date: Sat, 9 Oct 2004 14:47:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134738.GT16153@parcelfarce.linux.theplanet.co.uk>
References: <20041009134354.GA20025@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21951 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266864AbUJINrj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Oct 2004 09:47:39 -0400
Content-Disposition: inline
In-Reply-To: <20041009134354.GA20025@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: matthew@wil.cx, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Oct 09, 2004 at 03:43:54PM +0200, Christoph Hellwig wrote:
> -	void *ram_ptr;
> +	void __iomem *ram_ptr;

Thanks, I already got this one from Randolph Chung, it's in my tree and
I'll be pushing it for 2.6.10.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
