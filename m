From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 14:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015182247.GA4391@redhat.com>
References: <andersen@codepoet.org> <20021014203749.GA24904@codepoet.org> <200210142107.g9EL7IX04354@localhost.localdomain> <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015052521.GA1967@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Oct 14, 2002 at 11:25:22PM -0600, Erik Andersen wrote:
> 
> It is called from within the insmod's context.

So it's called by what module then?  And what happens if we have a user 
add a hard drive and it gets the module loaded and then attaches the 
drive, then we attach another drive sometime later, and this time hotplug 
doesn't do anything because the right module is already loaded?  How does 
the drive get added then?  Am I missing something?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
