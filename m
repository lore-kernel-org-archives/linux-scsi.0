From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/3] export scsi_forget_host
Date: Fri, 11 Jun 2004 21:19:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612041930.GA21105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:8334 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264628AbUFLETU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 00:19:20 -0400
Received: from westrelay05.boulder.ibm.com (westrelay05.boulder.ibm.com [9.17.193.33])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i5C4JJY0713544
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jun 2004 00:19:19 -0400
Received: from hmsbounty.us.ibm.com (sig-9-49-143-70.mts.ibm.com [9.49.143.70])
	by westrelay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i5C4JJvM283362
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 22:19:19 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In regards to the mail the other day about rmmod of a LLDD and the
errors generated if a child device of the LLDD had write cache enabled.
The url reference to the thread is provided below.

http://marc.theaimsgroup.com/?t=108689054100009&r=1&w=2

The sequence of patches is against 2.6 bk current but should also
apply with some offsets to scsi-misc-2.6.

The first patch is the export of the function. The second patch is an
example of a LLDD (scsi_debug) using the function. The third patch is
not functionally needed, but the scsi_forget_host function name did not
appear to fit the other api naming.

-andmike
--
Michael Anderson
andmike@us.ibm.com

