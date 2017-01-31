From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 21:58:15 +0300
Message-ID: <ebcc36be-9c02-eff3-33a0-20f7dedc3c0b@cogentembedded.com>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
 <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
 <1485888674.3199.49.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1485888674.3199.49.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/31/2017 09:51 PM, James Bottomley wrote:

>>> [1] which were a pain in the ass to untangle and debug during
>>> development, it's really time for it to die..
>>
>> Outside of the patch series in question, how to we expedite the
>> euthanasia of IDE? What explicit features/support are we missing
>> through libata that would need to be added, before we can git rm
>> drivers/ide/?
>
> I thought the primary objection was actually embedded in that libata

    Back at MontaVista, even embedded uses switched to libata years ago...
DaveM thinks we still can't prove that libata works everywhere the IDE works.
Besided, there are still a number of non-x86 drivers not converted over to 
libata (like DaVinci, etc.)...

> with its reliance on SCSI was just too large a dependency, so they have
> to keep using drivers/ide.

    Do you remember how many years ago a libata's own block driver was 
promised to you? ;-)
    I'd gladly wrote one, getting tired of my current OSS work... :-)

> Perhaps nvme and flash is obviating this
> problem and we can ask them again, though?

    What's wrong with those? I'm not really following NVMe...

> James

MBR, Sergei

