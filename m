From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Wed, 28 Jun 2017 06:51:17 -0600
Message-ID: <22e0adc4-3c02-e1f8-9017-213b50fdb8a8@kernel.dk>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
 <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
 <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B6FF1DA36@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B6FF1DA36@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, Ingo Molnar <mingo@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 06/28/2017 05:58 AM, Reshetova, Elena wrote:
> 
>> Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
>>
>> On Tue, Jun 27, 2017 at 6:26 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 06/27/2017 05:39 AM, Elena Reshetova wrote:
>>>> Changes in v3:
>>>> No changes in patches apart from trivial rebases, but now by
>>>> default refcount_t = atomic_t and uses all atomic standard operations
>>>> unless CONFIG_REFCOUNT_FULL is enabled. This is a compromize for the
>>>> systems that are critical on performance and cannot accept even
>>>> slight delay on the refcounter operations.
>>>
>>> Is that true in 4.12-rc, or is that true in a later release once
>>> Linus has pulled those changes in? If the latter, please resend
>>> this when those changes are in, thanks.
>>
>> It's in -next currently ("locking/refcount: Create unchecked atomic_t
>> implementation")
> 
> I would really like to start discussion on the these patches asap
> since it normally takes some adjustments etc. before they can be
> merged and we want many changes to go into next release round and not
> to miss the merge window. 

As far as I'm concerned, there's no need for a discussion on these. If
the other patches go in to make it as light weight as what we currently
have, then I'm fine with it. I can queue it up for post initial merge
submission.

-- 
Jens Axboe
