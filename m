From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 00/11] Zoned block device support
	improvements
Date: Thu, 25 Oct 2018 08:30:32 -0600
Message-ID: <d01f3553-eb95-34c2-a846-23f8dafaa4a3@kernel.dk>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<78778e22-9c5e-99d0-ef5c-85e04d03a4b7@kernel.dk>
	<yq1o9bkf5av.fsf@oracle.com>
	<20181024150344.GB13487@redhat.com> <yq1zhv3e4oe.fsf@oracle.com>
	<1540397093.66186.13.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1540397093.66186.13.camel@acm.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 10/24/18 10:04 AM, Bart Van Assche wrote:
> On Wed, 2018-10-24 at 11:37 -0400, Martin K. Petersen wrote:
>> Mike,
>>
>>>> You keep mentioning this, but I don't recall ever seeing anything to
>>>> that effect. The rest of the kernel appears to be either arbitrary
>>>> ordering or favoring author SoB as the first tag.
>>>
>>> I've always felt the proper order is how Jens likes it too (all dm
>>> commits from me follow that order).
>>
>> That's fine, I don't have any particular preference. And I don't have
>> any issue with you guys sticking to a certain ordering in your
>> respective subsystems. I occasionally shuffle tags when I commit things
>> in SCSI too.
>>
>> I just think it should be properly documented if there is a preferred
>> way to order things...
> 
> When I tried to look up documentation for this I couldn't find anything under
> the Documentation directory. Maybe it's there but I didn't look carefully
> enough. All I could find on the web is e-mails from Linus in which he explains
> that the order of Signed-off-by's should match the chain of authorship.

I don't think there's any documentation on it, none that I've seen.
Haven't looked for it, though.

It's more of a "it always looked like that", until we got patchwork messing
things up. And then people see that, and do the same. It's a bit
frustrating. I like to be able to see the SOB chain in a patch, and if
it's intermingled with other things, it's much harder to read. At least
for me.

I'll continue fixing these up, but I do hope that at least the regulars
on the block side use the proper formatting.

-- 
Jens Axboe
