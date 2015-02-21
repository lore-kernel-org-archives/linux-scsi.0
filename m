From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sat, 21 Feb 2015 22:48:53 +0200
Message-ID: <54E8EF35.4000903@dev.mellanox.co.il>
References: <54B63F74.2040702@sandisk.com> <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com> <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com> <54E7112F.2080901@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54E7112F.2080901@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/20/2015 12:49 PM, Bart Van Assche wrote:
> On 01/19/15 10:36, Bart Van Assche wrote:
>> On 01/19/15 10:22, Christoph Hellwig wrote:
>>> On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
>>>> My goal is to realize this proposal without adding hooks for out-of-tree
>>>> code in the upstream kernel. What I had in mind is to raise the
>>>> abstraction level of the API between LIO core and target drivers a
>>>> little bit (e.g. by using accessor functions where necessary instead of
>>>> accessing structure members directly)
>>>
>>> That's very much a hook, althiugh a week one.
>>>
>>> Either way I don't think bringing up a very much political topic
>>> without even any code to discuss isn't a very valueable use of our time
>>> slots.
>>
>> A possible approach is that I start implementing a unified SRP target
>> driver and post that driver together with the necessary LIO and SCST
>> core changes before the LSF/MM starts. That could be a helpful starting
>> point for further discussions.
>
> (replying to my own e-mail)
>
> Hello Christoph,
>
> What I proposed myself consists of three steps:
> 1. Updating the LIO SRP target driver to a more recent version.
> 2. Target driver and LIO core refactoring such that the LIO and
>     SCST APIs can be unified.
> 3. Adding support in SCST for the unified target driver API.
>
> This work is taking a little more time than I had expected - I still
> have to start with step (3). But I can already show in which direction I
> would like to go for steps (1) and (2). The 43 patches I came up with so
> far for steps (1) and (2) are available in the lio branch of the
> https://github.com/bvanassche/linux git repository. As you can see in
> that repository 42 of these 43 patches make sense even without knowing
> that something like SCST exists.

Hey Bart,

So other than the obvious srpt update (which is well needed..), the
other patches in the set look very useful. I'll go ahead and pull them
for tests.

Sagi.
