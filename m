From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Problem with megaraid-2.20.2.0 on Fedora Core 2
Date: 19 Aug 2004 11:52:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5g7jrvp2an.fsf@patl=users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:61457 "HELO
	mail-ext.curl.com") by vger.kernel.org with SMTP id S266536AbUHSPwR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 11:52:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Atul.Mukker@lsil.com

I am experimenting with Fedora Core 2 on a Dell PowerEdge 650 server.
The stock megaraid driver in the 2.6 kernel consistently crashes under
load within about 12 hours, so I thought I would give the LSI driver a
try.

I downloaded megaraid-2.20.2.0 from
<ftp://ftp.lsil.com/pub/linux-megaraid/> and built it against the
current Fedora Core 2 sources (kernel-2.6.7-1.494.2.2smp).  I edited
my /etc/modprobe.conf to include the line:

    alias scsi_hostadapter megaraid_mbox

Then I used "mkinitrd" to generate an initial ramdisk which includes
this module.

Shortly after boot, I get:

    Red Hat nash verison 3.5.22 starting
    <NULL>: can_queue = 0 no longer supported

Browsing drivers/scsi/hosts.c and megaraid_mbox.c itself, this appears
to mean that Linux has a handle to the controller which has not been
initialized.  But I do not know my way around the source, so I thought
I would see if anybody here could give me suggestions for how to
proceed.

Thanks!

 - Pat
