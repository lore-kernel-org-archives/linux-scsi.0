From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi.c::scsi_adjust_queue_depth(): adjust only once
Date: Thu, 14 Oct 2004 01:09:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014000942.GJ16153@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.60.0410132135240.3426@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2260 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269770AbUJNAJn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 20:09:43 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0410132135240.3426@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Oct 13, 2004 at 09:40:02PM +0200, Guennadi Liakhovetski wrote:
> Well, I spent, I think, about 5 minutes looking at this, and I still 
> cannot understand why this is needed. The best way to find out if I am 
> right or not is to send a patch:-) So, here goes.

I think you're right.  I also think the device_request_lock can go
(as noted by hch).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
