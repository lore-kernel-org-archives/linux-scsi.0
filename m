From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 05:39:06 +0900
Message-ID: <20130522203906.GC23845@mtj.dyndns.org>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
 <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522150335.GC2777@thunk.org>
 <519CE9FE.2030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519CE9FE.2030007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey,

On Wed, May 22, 2013 at 05:53:34PM +0200, Paolo Bonzini wrote:
> I do listen to review feedback, but I also expect the other side to
> listen to me, ask me what is not clear, and possess some knowledge of
> the domain that he's reviewing patches for.  All of which, quite
> frankly, I have not seen in this case.

Heh, nice one.  As we've talked on RH mailing list, I don't doubt this
has been a pretty bad experience for you but it also has been one of
the worst review experiences for me too.  It's on both of us that we
do get frustrated easily and the discussions escalate very quickly;
however, the biggest issue from my side is that it's very difficult to
get a point across and even when the point seems to have been made
what comes out of it is the mimum possible change around that point
rather than wider interpretation and application of the point made.
I'm not saying you don't listen to reviews at all but the reception
definitely feels very low-gain.

Anyways, at this point, the easiest way to make forward progress is
completely separating out security fix from the rest along with the
"count me out" knob, which should be able to cover most of the
described use cases anyway.  Let's please do further modifications to
the filtering table as a separate step.

-- 
tejun
