From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:00:25 +0200
Message-ID: <20100728090025.GA9252@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:51355 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab0G1JA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 05:00:59 -0400
Content-Disposition: inline
In-Reply-To: <4C4FF136.5000205@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, Jul 28, 2010 at 10:58:30AM +0200, Tejun Heo wrote:
> I see.  It probably would be good to have ordering requirements
> carried in the bio / request, so that filesystems can mix and match
> barriers of different strengths as necesasry.  As you seem to be
> already working on it, are you interested in pursuing that direction?

I've been working on that for a while, but it got a lot more urgent
as there's been an application hit particularly hard by the barrier
semantics on cache less devices and people started getting angry
about it.  That's why fixing this for cache less devices has become
a higher priority than solving the big picture.

