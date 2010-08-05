From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 06 Aug 2010 00:05:52 +0400
Message-ID: <4C5B19A0.9070200@vlnb.net>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5B1583.6070706@vlnb.net> <20100805195048.GA19030@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100805195048.GA19030@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 08/05/2010 11:50 PM wrote:
> On Thu, Aug 05, 2010 at 11:48:19PM +0400, Vladislav Bolkhovitin wrote:
>> So, I believe, Linux must use that possibility to get full storage
>> performance and to finally simplify its storage stack.
>
> So instead of talking what about doing a prototype and show us what
> improvement it gives?

Sure, I'd love to. But, unfortunately, I can't clone myself, so I'm 
trying to help the best of what I could: my level of storage and SCSI 
expertise. This area is quite special, so I'm trying to explain some 
misunderstandings I see and illustrate my points by some possible work 
flows and interfaces.

But I can shut up if you'd like.

Thanks,
Vlad
