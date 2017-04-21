From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Fri, 21 Apr 2017 17:22:41 +0200
Message-ID: <20170421152241.q45w3ckjax5xiddq@hirez.programming.kicks-ass.net>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
 <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
 <20170420183319.GB103004@gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8E21B@IRSMSX102.ger.corp.intel.com>
 <31311853-3554-cefe-1210-2ffae1a20058@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31311853-3554-cefe-1210-2ffae1a20058@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Eric Biggers <ebiggers3@gmail.com>, Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>, "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 21, 2017 at 08:03:13AM -0600, Jens Axboe wrote:
> You have it so easy - the code is completely standalone, building a
> small test framework around it and measuring performance in _user space_
> is trivial.

Something like this you mean:

  https://lkml.kernel.org/r/20170322165144.dtidvvbxey7w5pbd@hirez.programming.kicks-ass.net
