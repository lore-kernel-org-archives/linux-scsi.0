From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH, RFC] sym2: remove unkown data direction handling
Date: Tue, 2 Nov 2004 17:06:49 +0000
Message-ID: <20041102170649.GB24690@parcelfarce.linux.theplanet.co.uk>
References: <20041102111835.GA29191@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30368 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261343AbUKBRGv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 12:06:51 -0500
Content-Disposition: inline
In-Reply-To: <20041102111835.GA29191@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 12:18:35PM +0100, Christoph Hellwig wrote:
> since 2.3 the LLDD gets the data direction passed down, so we don't
> need to kludge around an unknown data direction anymore.  I've added
> a BUG when we get an unkown data direction neverless, and it seems to
> survive so far under low load.

I thought we could get an unknown data direction from certain ioctls?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
