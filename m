From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 05 Aug 2010 23:32:04 +0400
Message-ID: <4C5B11B4.9020807@vlnb.net>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805170933.GB10728@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0HETcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 15:32:15 -0400
In-Reply-To: <20100805170933.GB10728@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig, on 08/05/2010 09:09 PM wrote:
> On Thu, Aug 05, 2010 at 05:11:56PM +0400, Vladislav Bolkhovitin wrote:
>> Chris Mason, on 08/02/2010 09:39 PM wrote:
>>> I regret putting the ordering into the original barrier code...it
>>> definitely did help reiserfs back in the day but it stinks of magic and
>>> voodoo.
>>
>> But if the ordering isn't in the common (block) code, how to implement
>> the "hardware offload" for ordering, i.e. ORDERED commands, in an
>> acceptable way?
>
> Right now we have no working implementation of actually using ordered
> tags for a storage device in Linux. There's very little need for common
> code in that implementation - basically we just need flag in the bio /
> request to make this one an ordered tag in addition to the existing
> reordering preventing in the block queue.

New flag.. Easy to add, hard to live with. Aren't you already tied of 
the existing flags hell?

Vlad
