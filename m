From: Troy Klein <res1uo0c@verizon.net>
Subject: RE: Megaraid corruption?
Date: Thu, 09 Dec 2004 09:34:57 -0800
Message-ID: <1102613697.8512.31.camel@TroysLinux.verari.com>
References: <003301c4de14$38f885e0$1e01a8c0@rtlogic.com>
Reply-To: res1uo0c@verizon.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out014pub.verizon.net ([206.46.170.46]:64720 "EHLO
	out014.verizon.net") by vger.kernel.org with ESMTP id S261554AbULIRfE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 12:35:04 -0500
In-Reply-To: <003301c4de14$38f885e0$1e01a8c0@rtlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell Johnson <rjohnson@rtlogic.com>
Cc: 'Tom Coughlan' <coughlan@redhat.com>, linux-scsi@vger.kernel.org

What kernel version are you running?  I am running 2.4.21-20.ELsmp
(RedHat EL).

Does the megaraid compile with 2.4 kernels and if so how is that done
the source appears to be for 2.6?

Troy

On Thu, 2004-12-09 at 10:26 -0700, Russell Johnson wrote:
> There was a recent patch to the megaraid2 driver that fixed corruption
> while
> some ioctl's were executing during file operations.  You mentioned
> using
> megamgr.  If that is running in the background while you are
> performing the
> file copies, it could be causing the bug that was fixed in the most
> recent
> megaraid2 driver.
> 
> Try disabling megamgr and run your test...
> 
> Or try updating megaraid2 to the latest version.  I'm using 
> megaraid cmm: 2.20.2.0 (Release Date: Thu Aug 19 09:58:33 EDT 2004)
> megaraid: 2.20.4.0 (Release Date: Mon Sep 27 22:15:07 EDT)
> 

