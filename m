From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: status of block-integrity
Date: Tue, 07 Jan 2014 16:28:45 +0800
Message-ID: <52CBBABD.50902@gmail.com>
References: <20131222192128.GA28532@infradead.org> <yq11u134rmt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq11u134rmt.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/23/2013 09:35 PM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> Christoph> We have the block integrity code to support DIF/DIX in the
> Christoph> the tree for about 5 and a half years, and we still don't
> Christoph> have a single consumer of it.
>
> What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp)
> then integrity protection is active from the block layer down. The only
> code that's not currently being exercised are the tag interleaving
> functions.  I was hoping the FS people would use them for back pointers
> but nobody seemed to bite.
>
>
> Christoph> Given that we'll have a lot of work to do in this area with
> Christoph> block multiqueue I think it's time to either kill it off for
> Christoph> good or make sure we can actually use and test it.
>
> I don't understand why multiqueue would require a lot of work? It's just
> an extra scatterlist per request.
>
> And obviously, if there's anything that needs to be done in this area
> I'll be happy to do so...
>

One of the major knocks on linux file systems (except for btrfs) that I hear is 
the lack of full data path checksums. DIF/DIX + xfs or ext4 done right will give 
us another answer here.  I don't think it will be common, it is a request that 
comes in for very large storage customers most commonly.

We do have devices that support this and are working to get more vendor testing 
done, so I would hate to see us throw out the code instead of fixing it up for 
the end users that see value here.

I think that we can get this working & agree with the call to continue this 
discussion (here and at LSF :))

Ric
