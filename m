From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] serialize bus scanning
Date: Wed, 27 Aug 2003 15:32:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030827223250.GB2664@beaverton.ibm.com>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:24053 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262484AbTH0W3A
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 18:29:00 -0400
Content-Disposition: inline
In-Reply-To: <20030827202908.GB7852@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Anton Blanchard [anton@samba.org] wrote:
> Ive started playing with parallel probe in the lab (on some large ppc64
> boxes). I know we have a lot of work to do before this will all work,
> but would it be possible to make this semaphore per host?
> 
> Even with a per host semaphore, it annoys me how long it takes to spin
> up 7 disks especially if a few of them are dead. Longer term are we
> planning to overlap spinup of disks on the same host?
> 
> (We have a property in our device tree that says how quickly you can
> spin disks up on the same host, eg 1sec apart. We should also be able to
> do this in parallel on all hosts. We could easily read this property in
> a small initramfs program and then issue probe commands via /sys)
> 

Since I have not seen your tree I am speaking with lack of knowledge, but
it seems odd that your device tree would contain spinup knowledge per
host. The power issue you are trying to avoid is per disk enclosure
/ cabinet. A per host value seems like it could still lead to a power
issue given a large enough configuration. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

