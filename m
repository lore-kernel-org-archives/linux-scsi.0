From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 05 Aug 2010 17:11:56 +0400
Message-ID: <4C5AB89C.5080700@vlnb.net>
References: <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012Ab0HENMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 09:12:15 -0400
In-Reply-To: <20100802173930.GP16630@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.B

Chris Mason, on 08/02/2010 09:39 PM wrote:
> I regret putting the ordering into the original barrier code...it
> definitely did help reiserfs back in the day but it stinks of magic and
> voodoo.

But if the ordering isn't in the common (block) code, how to implement 
the "hardware offload" for ordering, i.e. ORDERED commands, in an 
acceptable way?

I believe, the decision was right, but the flags and magic requests 
based interface (and, hence, implementation) was wrong. That's it which 
stinks of magic and voodoo.

Vlad
