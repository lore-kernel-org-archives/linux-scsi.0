From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Fri, 06 Jun 2003 16:30:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0F9D2.2070907@rogers.com>
References: <20030606080103.GC18838@lst.de> <3EE0F86B.4060908@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:41663
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262269AbTFFUQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 16:16:36 -0400
In-Reply-To: <3EE0F86B.4060908@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> 
> Why don't you call this scsi_host_free() to complement scsi_host_alloc()?
> Why do you need to reveal implementation by naming it scsi_host_put()?
> As far as the caller of scsi_host_put() is concerned they MUST NOT
> dereference the host thereafter, so you can safely call it 
> scsi_host_free().
> (_When_ it is actually it is freed is what is being hidded as 
> implementation.)

Last sentence was meant to be:
 "_When_ it is actually freed is what is being hidden as implementation."

-- 
Luben




