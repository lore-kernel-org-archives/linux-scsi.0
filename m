From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 15:55:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015195516.GE4391@redhat.com>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org> <20021015191330.GC4391@redhat.com> <20021015193216.GE15778@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015193216.GE15778@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Oct 15, 2002 at 01:32:16PM -0600, Erik Andersen wrote:
> > about the scenario I asked about in my last email regarding a second disc 
> > and the situation where no module needs loaded?  How is that handled?
> 
> Same deal.  The 1394 nodemgr invokes /sbin/hotplug.

That doesn't answer the question.  Your patch provided a kernel interface
to be called by other kernel code (during module init time if I'm
correct).  As such, hotplug itself is *not* attaching the disk, it is
letting the module init take care of it.  If /sbin/hotplug isn't attaching
the disk, but instead it is being done by the kernel driver during insmod
(using the facilities provided by your patch), THEN HOW DOES IT HAPPEN
WHEN THE MODULE IS ALREADY LOADED?  Are you loading *another* copy of the
same module to handle the additional disk?  Do you have a facility by
which the hotplug manager can tell an existing module about a new disk?  
Or does it just not get added?  Or does the 1394 node manager notice that
the module for the new disk is already loaded and tell the module about
the new disk without even invoking hotplug?  Please answer this for me.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
