From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 23:43:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210152343.44931.oliver@neukum.name>
References: <andersen@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015184535.GA16401@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Dienstag, 15. Oktober 2002 20:45 schrieb Erik Andersen:
> On Tue Oct 15, 2002 at 02:22:47PM -0400, Doug Ledford wrote:
> > On Mon, Oct 14, 2002 at 11:25:22PM -0600, Erik Andersen wrote:
> > > It is called from within the insmod's context.
> >
> > So it's called by what module then?  And what happens if we have a user
> > add a hard drive and it gets the module loaded and then attaches the
> > drive, then we attach another drive sometime later, and this time hotplug
> > doesn't do anything because the right module is already loaded?  How does
> > the drive get added then?  Am I missing something?
>
> Oops.  I spoke wrongly....  It is called from within
> /sbin/hotplug's context.

That sounds very odd. Are you trying to say that it is done in the context
of a kernel thread which later calls /sbin/hotplug, or what?

	Regards
		Oliver

