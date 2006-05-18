From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 0/6] mpt fusion - fibre channel updates / bug fixes
Date: Thu, 18 May 2006 14:59:08 -0500
Message-ID: <446CD20C.9030700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:13753 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751391AbWERT7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 15:59:09 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4IMGuET010230
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 15:16:56 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k4IJx84126278029
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 12:59:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

If possible, 2.6.17.

Bugs fixed:

	* fibre channel target discovery prematurely terminates
	* fix infinite request/response loop during board reset
	* interrupting board reset with ctrl-c can leave board
	  unusable, requiring reboot to recover

Code reorg:

	* move fibre channel event and reset handling to mptfc
	  (better isolates future changes to this module)

Bug fix / feature: (depends upon point of view)

	* Set firmware target missing timers to one second so that
	  the transport's dev loss timer is more quickly started

