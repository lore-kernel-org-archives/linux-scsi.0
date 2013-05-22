From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 23:30:19 +0900
Message-ID: <20130522143019.GA18541@mtj.dyndns.org>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
 <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519CD234.40608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 04:12:04PM +0200, Paolo Bonzini wrote:
> Il 22/05/2013 15:41, Tejun Heo ha scritto:
> > On Wed, May 22, 2013 at 12:23:56PM +0200, Paolo Bonzini wrote:
> >> Yes, because I have no idea what _your_ point is.
> > 
> > Isolate the actual fixes and just submit them as it seems impossible
> > for you to provide proper justifications for the things you want to
> > add.
> 
> Quoting myself on January 26, 2013: "The vast majority of the commands
> are added because Linux itself is using them".

See, this is exactly what I've been talking about.  Reviewing or
raising points is almost useless.  Gees, why did I start this again?
Why the hell aren't my points clear yet after so many exchanges on the
exact same frigging subject?  Stop repeting yourself and try to
understand the review points for once.

* Separate fixes from additions.  Transform existing code so that the
  visible behavior doesn't change but the required fix can be
  implemented on top.  Explicitly note what's going on in the commit
  messages.

* Fix the frigging CVE bug that you've been waving around and do
  *just* that.

* Add the frigging "count me out" feature that you want for your use
  case.  It isn't controversial and is what you need and the
  maintainer can apply to the point where [s]he thinks acceptable.

* If for whatever reason you have to add more command codes to the
  exception table, do them with explicit justifications.  How the hell
  "the vast majority of the commands are added because Linux itself is
  using them" a proper justification?  How are they used for what
  reason and why is adding them beneficial?  How many times have I
  asked you to give at least some useful use cases?  And WTF is "vast
  majority", what about others then?  Why do you need this at all if
  you have the "count me out" knob in the first place?  You first
  built that command list by scanning the spec and just adding the
  commands that seemed "right" to you.  I have near-zero confidence in
  your perception of the relationship between the specs and actual
  world.

So, stop quoting and repeating yourself.  You're overdoing yourself on
that department already.  Try to listen and understand for a change.

-- 
tejun
