From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [bk patches] move scsi headers
Date: Tue, 27 May 2003 01:40:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED2FA6A.8040902@pobox.com>
References: <20030527034239.GA16376@gtf.org> <20030527061444.A1905@infradead.org> <3ED2F568.7060501@pobox.com> <20030527063513.A2357@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61899 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263516AbTE0F14
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 01:27:56 -0400
In-Reply-To: <20030527063513.A2357@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 27, 2003 at 01:19:36AM -0400, Jeff Garzik wrote:
> 
>>This is too ambitious this close to 2.6-pre,
> 
> 
> No, it's not.  Eihet we do it properly or not at all.  Having to use
> different headers for 2.4,2.6and 2.7/2.8 is just extremly stupid.

I'm going to send my patch to Marcelo too, since it doesn't break 
anything, and greatly reduces include annoyance for in-tree drivers 
outside drivers/scsi.


> Also we have more intrusive stuff in scsi pending, 2.6.pre or not.

We'll see what akpm says...

	Jeff




