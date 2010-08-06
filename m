From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] relaxed barriers
Date: Sat, 7 Aug 2010 01:34:30 +0200
Message-ID: <20100806233430.GA14751@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <4C5C3287.1010404@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56052 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758972Ab0HFXhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 19:37:08 -0400
Content-Disposition: inline
In-Reply-To: <4C5C3287.1010404@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

> Christoph, does this look like something the filesystems can use or
> have I misunderstood something?

This sounds very useful.  I'll review and test it once I get a bit time.

