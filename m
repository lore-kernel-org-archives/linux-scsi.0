From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Tue, 27 Jun 2017 07:26:55 -0600
Message-ID: <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, keescook@chromium.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
List-Id: linux-scsi@vger.kernel.org

On 06/27/2017 05:39 AM, Elena Reshetova wrote:
> Changes in v3:
> No changes in patches apart from trivial rebases, but now by
> default refcount_t = atomic_t and uses all atomic standard operations
> unless CONFIG_REFCOUNT_FULL is enabled. This is a compromize for the
> systems that are critical on performance and cannot accept even
> slight delay on the refcounter operations.

Is that true in 4.12-rc, or is that true in a later release once
Linus has pulled those changes in? If the latter, please resend
this when those changes are in, thanks.

-- 
Jens Axboe
