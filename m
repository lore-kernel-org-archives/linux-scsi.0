From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Wed, 31 Oct 2018 19:47:50 +0200
Message-ID: <6794b3a0-fe57-cd8b-3ad3-3a590121b12a@electrozaur.com>
References: <20181027082019.20838-1-hch@lst.de>
 <c9740eeb-6b96-35b6-a436-7537669da1a9@electrozaur.com>
 <1541006979.196084.138.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541006979.196084.138.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 31/10/18 19:29, Bart Van Assche wrote:
> On Wed, 2018-10-31 at 18:34 +0200, Boaz Harrosh wrote:
>> On 27/10/18 11:20, Christoph Hellwig wrote:
>>> The only real user of the T10 OSD protocol, the pNFS object layout
>>> driver never went to the point of having shipping products, and we
>>> removed it 1.5 years ago.  Exofs is just a simple example without
>>> real life users.
>>>
>>> The code has been mostly unmaintained for years and is getting in the
>>> way of block / SCSI changes, so I think it's finally time to drop it.
>>>
>>> Quote from Boaz:
>>>
>>> "As I said then. It is used in Universities for studies and experiments.
>>> Every once in a while. I get an email with questions and reports.
>>>
>>> But yes feel free to remove the all thing!!
>>
>> I think I'm changing my mind about this.
>> [ ... ]
> 
> The osd driver was accepted in the upstream kernel in 2009. I have checked all
> commits in Linus' tree for the osd driver that went in since 2009. All changes
> made by other kernel developers than you are the result of tree-wide refactoring,
> compiler warning fixes, fixes for issues detected by static source code
> analyzers or spelling fixes. Hence my question: how big is the user base of the
> exofs and osd kernel drivers? 
> 

Not big at all. And none of them production setups. As I said mainly used
by academia.

Thanks
Boaz

> Thanks,
> Bart.
