From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 17:54:07 -0500
Message-ID: <200710151754.08795.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762350AbXJOWya@vger.kernel.org>
In-Reply-To: <20071015172513.GA5738@kroah.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Monday 15 October 2007 12:25:13 pm Greg KH wrote:
> Oh, and this seems like a very Ubuntu specific rant, might I suggest you
> contact the Ubuntu developers about this?  The kernel doesn't dictate
> that the distro has to use these long identifiers, and there is nothing
> we can do about it.

I was just trying to use the strangeness in a large distributor's first 
attempt at this functionality as an evidence that it's apparently not trivial 
to get even the common cases right under the new model, while the common 
cases used to be trivial to get right under the old model.  (Or at least it 
seemed so to me.)

I think I've exhausted this line of argument, though, and will stop now.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
