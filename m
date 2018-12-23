From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Sun, 23 Dec 2018 14:17:49 +0200
Message-ID: <fcba6f10-3cef-bc71-f198-e53e4a0e98e6@electrozaur.com>
References: <20181111133211.13926-1-hch@lst.de>
 <4f4b6aff-6726-c500-e3e4-f8b73d641851@electrozaur.com>
 <20181219144347.GB23410@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181219144347.GB23410@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19/12/18 16:43, Christoph Hellwig wrote:
> On Mon, Nov 26, 2018 at 07:11:10PM +0200, Boaz Harrosh wrote:
>> On 11/11/18 15:32, Christoph Hellwig wrote:
>>> The only real user of the T10 OSD protocol, the pNFS object layout
>>> driver never went to the point of having shipping products, and we
>>> removed it 1.5 years ago.  Exofs is just a simple example without
>>> real life users.
>>>
>>
>> You have failed to say what is your motivation for this patchset? What
>> is it you are trying to fix/improve.
> 
> Drop basically unused support, which allows us to
> 
>  1) reduce the size of every kernel with block layer support, and
>     even more for every kernel with scsi support

Do you have numbers? its mainly code-segment so I don't think you will see
any real life measurable difference.

>  2) reduce the size of the critical struct request structure by
>     128 bits, thus reducing the memory used by every blk-mq driver
>     significantly, never mind the cache effects

128 bits? I see the "struct request *next_rq;"
is there another one?

It could share space with elv; && flush;
Do you want a patch?

>  3) stop having the maintainance overhead for this code in the
>     block layer, which has been rather painful at times
> 

I hear you man. Life is pain. But is it really such an overhead?
I mean it is already implemented. What else is there to do?
Please please show me? (Sorry for being slow)

Jai Maa
Boaz
