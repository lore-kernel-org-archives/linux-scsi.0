From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sun, 16 Aug 2009 10:26:03 -0400
Message-ID: <4A8816FB.8070408@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8802F3.6010908@rtr.ca> <4A8810C4.3050800@rtr.ca> <20090816142331.GA4284@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090816142331.GA4284@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Aug 16, 2009 at 09:59:32AM -0400, Mark Lord wrote:
>> Okay, I got Matthews patches updated onto 2.6.31, and fixed the incompatibilities
>> between those and the XFS TRIM patch (from Christoph), plus a sector_t printk issue.
>>
>> My apologies for attachments, but I am attaching the updated Christoph patch,
>> as well as my hacked-up forward-port of Matthew's patches.
>>
>> Not pretty, but they work.  :)
>>
>> Now.. running Christoph's "xfs trim" on a 4.6GB mostly already-trimmed
>> XFS partition gave this for the first time around:
> 
>> The problem is, it still issues TRIMs to the LLD one extent at a time.
>> Compare this with doing it all in a single TRIM command
>> with the wiper.sh script (filesystem unmounted):
> 
> I could do a variant which issues a single TRIM, but that would require
> us to lock out all other allocations for the time the trim takes.  I'll
> hack that up once I get some time.
..

Matthew's stuff will have to change to support that, too.
