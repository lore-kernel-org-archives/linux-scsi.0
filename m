From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: mptsas suspend not working?
Date: Wed, 11 Oct 2006 16:30:19 -0700
Message-ID: <452D7E8B.6000907@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:234 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1161288AbWJKXaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 19:30:21 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9BNUWif010939
	for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2006 19:30:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9BNUK1d141244
	for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2006 19:30:20 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9BNUKal032092
	for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2006 19:30:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Eric Moore <eric.moore@lsil.com>

Hi Eric, et. al.:

I tried to put a mptsas controller into D3 suspend state while preparing
to put a system into standby mode.  When I went out of standby, I got
these errors in dmesg and all disk I/O ceased.  Any idea what's going on
here?  Kernel is 2.6.19-rc1, btw.

--D

[514076.973779] mptsas 0000:01:00.0: suspend
[514076.973786] mptbase: ioc0: pci-suspend: pdev=0xffff8100bb13c800, slot=0000:01:00.0, Entering operating state [D3]
[514077.361178] mptsas 0000:01:00.0: LATE suspend
[514129.109268] mptsas 0000:01:00.0: EARLY resume
[514129.388680] mptsas 0000:01:00.0: resuming
[514129.388684] mptbase: ioc0: pci-resume: pdev=0xffff8100bb13c800, slot=0000:01:00.0, Previous operating state [D3]
[514129.512441] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
[514129.512443] mptbase: Initiating ioc0 recovery
[514132.364805] mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
[514132.420725] mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
[514132.476662] mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
[514132.484649] mptbase: ioc0: pci-resume: Cannot recover, error:[fffffffe]
