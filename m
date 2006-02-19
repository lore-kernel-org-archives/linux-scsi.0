From: Willem Riede <osst@riede.org>
Subject: Re: osst changes required to move forward to block request
Date: Sun, 19 Feb 2006 15:27:44 -0500
Message-ID: <1140380864l.23688l.6l@athena.riede.org>
References: <20060206131944.GA1769@lst.de>
	<1139274141l.7464l.1l@athena.riede.org>
	<20060207091254.GA11691@infradead.org>
	<1139687216l.24984l.0l@athena.riede.org> <20060214192447.GA20864@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:4789 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751021AbWBSU16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2006 15:27:58 -0500
In-Reply-To: <20060214192447.GA20864@lst.de> (from hch@lst.de on Tue Feb 14
	14:24:47 2006)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>

On 02/14/2006 02:24:47 PM, Christoph Hellwig wrote:
> 
> Looks good.  I didn't think about keeping the reuse and dealing with it
> in osst_do_scsi, but this obviously works.  Please tell if you're
> confident enough with it so we can put it in the for-2.6.17 tree.
> 
> Long-term we should probably get rid of the request reuse anyway,
> because it's not nessecary anymore and would make the code more
> readable.

I agree that would make the code easier to understand, but it will be a  
significant impact on the logic of the driver, whereas the current patch is  
relatively low impact. Which is exactly the reason why, yes, I do feel the  
change can at least be put in the -mm series and then migrate if we don't get  
any problem reports.

Thanks, Willem Riede.
