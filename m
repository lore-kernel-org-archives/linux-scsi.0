From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Sat, 07 Jun 2003 14:55:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE2350E.7090104@rogers.com>
References: <20030606080103.GC18838@lst.de> <3EE0F86B.4060908@rogers.com> <20030606204241.GA28264@lst.de> <3EE121A7.8010806@rogers.com> <20030607064456.GA1668@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:2694
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263375AbTFGSlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2003 14:41:42 -0400
In-Reply-To: <20030607064456.GA1668@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> It's not.  It's alloc[, get, put, get, put], put.  alloc is
> get a new dynamic allocate structure with refcount one, after
> that we can get another reference with get, or a reference from hostno
> with lookup and then put it again - when the refcount reches zero
> it's freed.

Doh!

You're right.

-- 
Luben



