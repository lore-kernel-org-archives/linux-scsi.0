From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Tue, 27 Jun 2017 15:13:31 -0700
Message-ID: <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com> <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38396 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdF0WNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 18:13:33 -0400
Received: by mail-it0-f44.google.com with SMTP id b205so23842841itg.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2017 15:13:33 -0700 (PDT)
In-Reply-To: <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Elena Reshetova <elena.reshetova@intel.com>, James Bottomley <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, fujita.tomonori@lab.ntt.co.jp, Ingo Molnar <mingo@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>

On Tue, Jun 27, 2017 at 6:26 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/27/2017 05:39 AM, Elena Reshetova wrote:
>> Changes in v3:
>> No changes in patches apart from trivial rebases, but now by
>> default refcount_t = atomic_t and uses all atomic standard operations
>> unless CONFIG_REFCOUNT_FULL is enabled. This is a compromize for the
>> systems that are critical on performance and cannot accept even
>> slight delay on the refcounter operations.
>
> Is that true in 4.12-rc, or is that true in a later release once
> Linus has pulled those changes in? If the latter, please resend
> this when those changes are in, thanks.

It's in -next currently ("locking/refcount: Create unchecked atomic_t
implementation")

-Kees

-- 
Kees Cook
Pixel Security
