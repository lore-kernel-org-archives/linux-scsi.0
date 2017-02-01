From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: remove the cmd_type field from struct request
Date: Wed, 1 Feb 2017 13:55:34 +0300
Message-ID: <f7db63ea-7bae-8faf-b22e-42678018e04b@cogentembedded.com>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
 <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
 <c61b9b98-8e4a-ac23-bf0c-002d112d5468@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c61b9b98-8e4a-ac23-bf0c-002d112d5468@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/1/2017 9:53 AM, Hannes Reinecke wrote:

>>> [1] which were a pain in the ass to untangle and debug during development,
>>> it's really time for it to die..
>>
>> Outside of the patch series in question, how to we expedite the
>> euthanasia of IDE? What explicit features/support are we missing through
>> libata that would need to be added, before we can git rm drivers/ide/ ?
>>
> There is only a single driver (sgi_ide) which hasn't been moved over to
> libata.

    Huh? What about Toshiba TC86C001 and TX4938/9, TI DaVinci? That's off the 
top of my head only...

> But this is for an old Itanium-based server only, and even SGI didn't
> press us to have this ported.
> (And we have disabled the IDE drivers since SLES11, where we still support
> Itanium.)

    Or do you mean only the drivers SuSe is interested in?

[...]
> Cheers,
>
> Hannes

MBR, Sergei
