From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 14:34:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015183405.GB4391@redhat.com>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150019.53689.oliver@neukum.name> <20021015002252.GE1274@redhat.com> <200210150953.29905.oliver@neukum.name> <20021015143533.GA4288@redhat.com> <20021015174708.GA15778@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015174708.GA15778@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: Erik Andersen <andersen@codepoet.org>
Cc: Oliver Neukum <oliver@neukum.name>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Oct 15, 2002 at 11:47:08AM -0600, Erik Andersen wrote:
> On Tue Oct 15, 2002 at 10:35:33AM -0400, Doug Ledford wrote:
> > Now, please, someone tell me why everyone is whining about user space 
> > doing so little to accomplish what the much larger patch that was 
> > posted does in kernel space?  My point is, and was, that since we need the 
> 
> Much larger patch?  If you look closely, that patch is actually
> very small.  It simply moves the code already the proc/scsi/scsi
> "scsi add-single-device" and "scsi remove-single-device" handlers
> into standalone functions.  There is actually not so much as a
> single line of new code...

Well, there is to.  You then export the functions.  Aside from the export 
and the intended use, I'm actually all for the patch and moving that code 
into separate functions.  I just don't want those functions called from 
all over the place.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
