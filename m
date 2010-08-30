From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH, RFC 2/2] dm: support REQ_FLUSH directly
Date: Mon, 30 Aug 2010 10:33:12 +0200
Message-ID: <4C7B6CC8.5080609@kernel.org>
References: <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <20100803185148.GA12258@lst.de> <4C58F341.9060605@ct.jp.nec.com> <20100804085423.GA15687@lst.de> <4C5A1F05.40308@ce.jp.nec.com> <20100826225024.GB17832@redhat.com> <4C771852.3050500@ce.jp.nec.com> <20100827040808.GA19488@redhat.com> <4C7752B5.3020905@ce.jp.nec.com> <20100827141314.GB22504@redhat.com> <4C7B3760.2070201@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C7B3760.2070201@ce.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, tytso@mit.edu, swhiteho@redhat.com, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 08/30/2010 06:45 AM, Jun'ichi Nomura wrote:
> Hi Mike,
> 
> (08/27/10 23:13), Mike Snitzer wrote:
>>> If there will be no need for supporting a request-based target
>>> with num_flush_requests > 1, the special handling of flush
>>> can be removed.
>>>
>>> And since there is no such target in the current tree,
>>> I don't object if you remove that part of code for good reason.
>>
>> OK, certainly something to keep in mind.  But _really_ knowing the
>> multipath FLUSH+FUA performance difference (extra special-case code vs
>> none) requires a full FLUSH conversion of request-based DM anyway.
>>
>> In general, request-based DM's barrier/flush code does carry a certain
>> maintenance overhead.  It is quite a bit of distracting code in the core
>> DM which isn't buying us anything.. so we _could_ just remove it and
>> never look back (until we have some specific need for num_flush_requests
>>> 1 in rq-based DM).
> 
> So, I'm not objecting to your idea.
> Could you please create a patch to remove that?

I did that yesterday.  Will post the patch soon.

Thanks.

-- 
tejun
