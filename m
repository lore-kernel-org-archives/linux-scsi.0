From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 16:07:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015220758.GB19530@codepoet.org>
References: <andersen@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org> <200210152343.44931.oliver@neukum.name>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210152343.44931.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue Oct 15, 2002 at 11:43:44PM +0200, Oliver Neukum wrote:
> Am Dienstag, 15. Oktober 2002 20:45 schrieb Erik Andersen:
> > On Tue Oct 15, 2002 at 02:22:47PM -0400, Doug Ledford wrote:
> > > On Mon, Oct 14, 2002 at 11:25:22PM -0600, Erik Andersen wrote:
> > > > It is called from within the insmod's context.
> > >
> > > So it's called by what module then?  And what happens if we have a user
> > > add a hard drive and it gets the module loaded and then attaches the
> > > drive, then we attach another drive sometime later, and this time hotplug
> > > doesn't do anything because the right module is already loaded?  How does
> > > the drive get added then?  Am I missing something?
> >
> > Oops.  I spoke wrongly....  It is called from within
> > /sbin/hotplug's context.
> 
> That sounds very odd. Are you trying to say that it is done in the context
> of a kernel thread which later calls /sbin/hotplug, or what?

I was wrong again.  See the msg I just posted where (rather than
guessing) I actually test things....

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
