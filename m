From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Thu, 20 Apr 2017 06:56:51 -0700
Message-ID: <20170420135651.GA26595@infradead.org>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com
List-Id: linux-scsi@vger.kernel.org


All the objections from DaveM on the amount of cycles spent on the
new refcount_t apply to the block layer fast path operations as well.

Please don't send any more conversions until those have been resolved.
