From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 18:32:49 +0900
Message-ID: <20130522093249.GC3466@mtj.dyndns.org>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519C674A.50700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 08:35:54AM +0200, Paolo Bonzini wrote:
> I'm not sure what is more ridiculous, whether the seven pings or the
> lack of review...

So, ummm, I don't know what Jens is thinking but at this point I'm
basically waiting for someone else to pick it up as review to return
ratio is too low to continue.  It doesn't seem like I can get the
series into a shape I can ack with reasonable amount of effort.

My memory is kinda hazy now but here are two review points that came
to my mind before giving up.

* The response that I got after asking for justification basically
  boiled down to "it has to".  Whatever that means.

* In the patch series, fixes and feature changes are still mixed in
  order.  I gave up after this.

Thanks and good luck.

-- 
tejun
