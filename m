From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ISCSI
Date: Sun, 12 Dec 2004 16:07:24 -0500
Message-ID: <200412122107.iBCL7T902320@www.watkins-home.com>
References: <1102877722.3012.100.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:61878 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262115AbULLVHj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Dec 2004 16:07:39 -0500
In-Reply-To: <1102877722.3012.100.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>

As suggested, I am attempting to install UNH iSCSI, but having some
problems.

Readme says:
- The appropriate way to install this package is :
   1. mkdir <name> ; tar -zxf <tarball>
   2. cd <name>/unh_iscsi/src/
   3. ./Configure
   4. make rpm
   5. rpm -ivh  /usr/src/redhat/RPMS/i386/unh_iscsi-1.5-0X.i386.rpm

When I do "make rpm" I get this error:
tar cf /usr/src/redhat/SOURCES/unh_iscsi.tar  .
tar: /usr/src/redhat/SOURCES/unh_iscsi.tar: Cannot open: No such file or
directory
tar: Error is not recoverable: exiting now
make: *** [rpm] Error 2

Are there some prerequisites that are needed?
Or am I just doing something wrong.

Also, could you give me a link to SCST?  Or is this included in UNH iSCSI?

Thanks,
Guy


-----Original Message-----
From: Ming Zhang [mailto:mingz@ele.uri.edu] 
Sent: Sunday, December 12, 2004 1:55 PM
To: Guy
Cc: linux-scsi
Subject: Re: ISCSI

i suggest u to use UNH iSCSI + SCST. it provides a bypass mode which fit
you needs. IET will support a bypass interface later.

Ming

On Sun, 2004-12-12 at 13:08, Guy wrote:
> I have a SCSI tape drive on my Linux system.  I want to use the tape drive
> from another system with another (evil) OS.  I have found more than 1
source
> forge project related to ISCSI.  These projects seem to only talk about
disk
> access (SAN), not tape access.  I can't determine which I should use, if
> any.
> 
> Does anyone know which is best?
> I have kernel 2.4.28, but would be willing to attempt an upgrade if
needed.
> 
> Thanks,
> Guy
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

