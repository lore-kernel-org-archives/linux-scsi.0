From: Doug Ledford <dledford@redhat.com>
Subject: Re: [TRIVIAL] Re: aic7xxx gcc3 warning fix
Date: Fri, 26 Jul 2002 15:58:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020726155844.B10255@redhat.com>
References: <20020726071547.F2B6D4806@lists.samba.org> <20020726101754.A6596@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726101754.A6596@infradead.org>; from hch@infradead.org on Fri, Jul 26, 2002 at 10:17:54AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Trivial Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org

On Fri, Jul 26, 2002 at 10:17:54AM +0100, Christoph Hellwig wrote:
> Can't we just remove this stupid option parsing entirely in 2.5 and make it
> take sane module options?  

And just how do you define sane module options for a driver that is both 
module and built in capable and that should support the same set of 
options in both places without exceeding the maximum linux command line 
length in either place?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
