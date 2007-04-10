From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: SCSI breakage on PowerMac 9500 (oldworld) between 2.6.19.7 and
 2.6.20
Date: Tue, 10 Apr 2007 15:53:59 -0700
Message-ID: <20070410155359.cf82f5ea.randy.dunlap@oracle.com>
References: <20070410221217.GA21776@galaxy.int.geweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:28685 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXDJWxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2007 18:53:12 -0400
In-Reply-To: <20070410221217.GA21776@galaxy.int.geweb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Geier <linux-scsi@ml.martin.geweb.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 11 Apr 2007 00:12:17 +0200 Martin Geier wrote:

> Hi,
> 
> it seems SCSI got broken somewhere on the way from 2.6.19.7 to 2.6.20 on
> oldworld Apple PowerMacs 9500 using the internal mesh-controller. The
> kernel fails to read the partition table from the drive(s) with the
> following messages:
> | mesh_host_reset
> | mesh: target 0 synchronous at 10.0 MB/s
> | sd 0:0:0:0: scsi: Device offlined - not ready after error recovery
> | sd 0:0:0:0: rejecting I/O to offline device
> | sd 0:0:0:0: rejecting I/O to offline device
> | sd 0:0:0:0: rejecting I/O to offline device
> | sd 0:0:0:0: rejecting I/O to offline device
> | sda : READ CAPACITY failed.
> | sda : status=0, message=00, host=1, driver=00 
> | sda : sense not available. 
> | sd 0:0:0:0: rejecting I/O to offline device
> | sda: Write Protect is off
> | sd 0:0:0:0: rejecting I/O to offline device
> | sda: asking for cache data failed
> | sda: assuming drive cache: write through
> | sd 0:0:0:0: Attached scsi disk sda
> (...)
> 
> mesh.c and mesh.h (in drivers/scsi/) are identical between the two versions,
> so it seems that this is something at a different layer...
> Maybe it's connected to http://marc.info/?l=linux-scsi&m=117596425706527&w=2
> but my test of 2.6.21-rc5 failed similarly to the test of 2.6.20.
> 
> You can find kernel-config, full boot-time-output and build-logs at
> http://www.geweb.net/tmp/linux-kernel/
> README contains the commands used (on a debian r3.1 sarge box) if you'd
> like to check the builds (see linux-$VERSION for precise make-calls).
> 
> I can test a version between the two mentioned above if you let me know which
> one.

There was a similar report for the imm driver, with a follow-up
report that 2.6.21-rc5 works.  Could you test 2.6.21-rc6?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
