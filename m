From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 12:09:34 -0700
Message-ID: <1402686574.2224.61.camel@dabdike.int.hansenpartnership.com>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
	 <20140613185221.GA11872@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45802 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaFMTJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 15:09:37 -0400
In-Reply-To: <20140613185221.GA11872@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Venkatesh Srinivas <venkateshs@google.com>, hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Fri, 2014-06-13 at 11:52 -0700, Christoph Hellwig wrote:
> On Fri, Jun 13, 2014 at 10:58:22AM -0700, Venkatesh Srinivas wrote:
> > CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
> > enable no_async_abort until the problem is better-understood.
> 
> No patch attached.  Nevermind this is not a consdervative fix, but a
> band aid.  The proper fix is to figure out what's actually going on
> here.
> 
> >From your trace above it very much looks like a double completion of
> some sort.
> 
> I've looked at the virtio-scsi code a bit, and one odd thing it does
> that comes in handy here is that it doesn't really use a traditional
> tag, but rather the address of the scsi command.

What kernel version?  This is the exact signature of the original USB
REQUEST_SENSE problem.

James


