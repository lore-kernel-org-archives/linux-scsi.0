From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] move some constants around
Date: Sat, 20 Sep 2003 15:17:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6CA7BA.8080701@pobox.com>
References: <20030920133335.GA23251@lst.de> <20030920185037.A3530@pclin040.win.tue.nl> <20030920181149.GA26141@lst.de> <20030920203458.A3552@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38091 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261342AbTITTR2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 15:17:28 -0400
In-Reply-To: <20030920203458.A3552@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> On Sat, Sep 20, 2003 at 08:11:49PM +0200, Christoph Hellwig wrote:
> 
> 
>>The current design purpose of include/scsi/ is to be for the kernel
>>only.  glibc has it's own scsi/ headers.  and drivers/scsi/scsi.h
>>is going away completly (slowly).
> 
> 
> Yes, I see that that is what you are doing.
> Pity.
> 
> One of the projects that has been delayed far too much is the
> project of giving Linux headers that can be used in user space.
> There were only few of those.
> 
> Now you are polluting even those few.


Yes.  Oh well :(  More work for me, when I tackle that project...

	Jeff



