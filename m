From: Jens Axboe <axboe@kernel.dk>
Subject: Re: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 13:09:49 -0800
Message-ID: <deae073a-ae3b-eedb-5c86-4f52746a281c@kernel.dk>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
 <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
 <1485888674.3199.49.camel@HansenPartnership.com>
 <ebcc36be-9c02-eff3-33a0-20f7dedc3c0b@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ebcc36be-9c02-eff3-33a0-20f7dedc3c0b@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/31/2017 10:58 AM, Sergei Shtylyov wrote:
> On 01/31/2017 09:51 PM, James Bottomley wrote:
> 
>>>> [1] which were a pain in the ass to untangle and debug during
>>>> development, it's really time for it to die..
>>>
>>> Outside of the patch series in question, how to we expedite the
>>> euthanasia of IDE? What explicit features/support are we missing
>>> through libata that would need to be added, before we can git rm
>>> drivers/ide/?
>>
>> I thought the primary objection was actually embedded in that libata
> 
>     Back at MontaVista, even embedded uses switched to libata years ago...

Indeed, that would be my assumption as well, not too worried about that
side.

> DaveM thinks we still can't prove that libata works everywhere the IDE works.
> Besided, there are still a number of non-x86 drivers not converted over to 
> libata (like DaVinci, etc.)...

That argument is getting harder to buy. IDE has become a considerable
maintenance burden - not for Dave, but for the rest of us that have
to carry a subsystem forward. Personally I would _love_ to kill IDE
at some point in the future, where that future hopefully isn't too far
off. But if we have hardware that is being used and where IDE works and
libata support does not exist, then weneed to fix that first.

>     Do you remember how many years ago a libata's own block driver was 
> promised to you? ;-)
>     I'd gladly wrote one, getting tired of my current OSS work... :-)

Pretty sure I told Jeff originally that libata should only go into the
kernel, if there was a plan to make it independent of SCSI. A promise
was made that of course it would, but that promise was never held,
unfortunately.

-- 
Jens Axboe
