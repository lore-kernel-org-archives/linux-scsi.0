From: Doug Ledford <dledford@redhat.com>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 17:58:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117225807.GK3280@redhat.com>
References: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:35:52PM -0500, Ming Zhang wrote: > Hi, Doug > >
For example, like the iSCSI target code, when it start, it should find all
SCSI disks or tapes link in order to export to client side. It need the
scsi_device pointer in order to send requests to it. That is why I need
it. Is there a formal way to find a scsi_device pointer by its lun, host
id, ... or by block layer major number and minor number?

There is a process by which it can be found, but it's too long to do on 
each command.  That means you need to hold a pointer to the device open 
to make this not be a performance slug.  What are you doing to hold a 
refcount on the devices you grab the pointer for so that they don't get 
freed without you knowing it?

P.S. - Enabling word wrap in your mailer would be most appreciated.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
