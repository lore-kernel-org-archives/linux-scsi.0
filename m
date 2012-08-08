From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Wed, 08 Aug 2012 07:37:27 +0000
Message-ID: <50221737.3010608@acm.org>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu> <501D83A1.7040900@acm.org> <501DA3F0.4090009@cs.wisc.edu> <50200561.4020100@acm.org> <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com> <5020E031.9080406@acm.org> <CAOAMb1BNSTaG8N68jcEDV3gNt6V7BM9HkjUuXHeebhLNHe18kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1BNSTaG8N68jcEDV3gNt6V7BM9HkjUuXHeebhLNHe18kA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/08/12 03:42, Chanho Min wrote:
> Thank you for the explanation. It look correct. Let's check one more thing.
> What If __scsi_remove_device doesn't release device? : reference count
> is more than 2.
> So We lost starved_list but device is exist. Is there any issue about this?

As far as I can see that scenario will also be handled correctly by the
proposed patch.

Bart.
