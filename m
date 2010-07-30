From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 17:09:52 +0400
Message-ID: <4C52CF20.6090404@vlnb.net>
References: <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <4C52C994.2040405@vlnb.net> <20100730125750.GB26118@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100730125750.GB26118@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 07/30/2010 04:57 PM wrote:
> On Fri, Jul 30, 2010 at 04:46:12PM +0400, Vladislav Bolkhovitin wrote:
>> I supposed, with write back cache you did the queue drain after
>> request(s) with ordered requirements, correct? Did you also do the queue
>> drain in the same places with write through caching?
>
> Using the queue drains in both cases.  I can only imagine keeping the
> queue drained over the cache flush instead of just a few small I/Os
> has nasty side effects.

Sorry, I can't follow you here. What was the load pattern difference 
between the tests in the way how the backend device saw it? I thought, 
it was only in absence of the cache flush commands (SYNCHRONIZE_CACHE?) 
in the write through case, but looks like there is something more different?

Thanks,
Vlad
