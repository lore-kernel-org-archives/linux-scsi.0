From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: Strange Scsi_Cmnd->request_buffer addresses
Date: Fri, 2 Aug 2002 14:17:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <45B36A38D959B44CB032DA427A6E10640167D014@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


Mike Anderson wrote:

> Stephen,
> 	No idea what is causing the problem just a few comments.
> 
> Stephen Cameron [steve.cameron@hp.com] wrote:
> > Hi,
> > 
> > I'm seeing some strange Scsi_Cmnd->request_buffer addresses....
> 

Doh!  I see the problem.  I went to the trouble of calling
copy_to_user() to copy the data to or from user space into
a kernel buffer, but then, like a dummy, I passed the user
space buffer into scsi_wait_req() and never used the kernel 
buffer.
Thanks for the help.

-- steve
