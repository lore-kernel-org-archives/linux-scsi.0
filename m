From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Fri, 06 Jun 2003 19:20:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE121A7.8010806@rogers.com>
References: <20030606080103.GC18838@lst.de> <3EE0F86B.4060908@rogers.com> <20030606204241.GA28264@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:25161
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262341AbTFFXGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 19:06:33 -0400
In-Reply-To: <20030606204241.GA28264@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> scsi_host_get/scsi_host_put are the refcounting primites for
> struct Scsi_Host and there are more users then just the host drivers.
> (and there will be more soon).  It's an idiom in linux to use get/put
> for those and make put free it when the refcount reaches zero.

I know about the get/put idiom, refcounting, etc.

*But* your use is alloc <--> put.  This is what throws me off.

Either go with alloc <--> free or with get <--> put.  But cross-breeding
them is not that good an idea.

-- 
Luben


