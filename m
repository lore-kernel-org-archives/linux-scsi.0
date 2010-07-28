From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:17:06 +0200
Message-ID: <4C4FF592.9090800@kernel.org>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0G1JRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 05:17:30 -0400
In-Reply-To: <20100728090025.GA9252@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 07/28/2010 11:00 AM, Christoph Hellwig wrote:
> On Wed, Jul 28, 2010 at 10:58:30AM +0200, Tejun Heo wrote:
>> I see.  It probably would be good to have ordering requirements
>> carried in the bio / request, so that filesystems can mix and match
>> barriers of different strengths as necesasry.  As you seem to be
>> already working on it, are you interested in pursuing that direction?
> 
> I've been working on that for a while, but it got a lot more urgent
> as there's been an application hit particularly hard by the barrier
> semantics on cache less devices and people started getting angry
> about it.  That's why fixing this for cache less devices has become
> a higher priority than solving the big picture.

Well, if disabling barrier works around the problem for them (which is
basically what was suggeseted in the first message), that's not too
bad for short term, I think.  At least, there's a handy workaround.
I'll re-read barrier code and see how hard it would be to implement a
proper solution.

Thanks.

-- 
tejun
