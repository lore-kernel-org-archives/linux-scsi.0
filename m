From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Sat, 7 Aug 2010 01:34:59 +0200
Message-ID: <20100806233459.GB14751@lst.de>
References: <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5B1583.6070706@vlnb.net> <20100805195048.GA19030@lst.de> <4C5B19A0.9070200@vlnb.net> <4C5C22B8.9040109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57545 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760423Ab0HFXtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 19:49:04 -0400
Content-Disposition: inline
In-Reply-To: <4C5C22B8.9040109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Fri, Aug 06, 2010 at 04:56:56PM +0200, Hannes Reinecke wrote:
> But I can do bonnie runs in no time.
> I have done some preliminary benchmarks by just enable ordered
> queueing in sd.c and no other changes.

Enabled what exactly?

