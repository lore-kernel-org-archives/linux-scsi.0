From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/2] aic94xx / sas: ref count update
Date: Wed, 22 Mar 2006 13:41:19 -0800
Message-ID: <20060322214119.GA661@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45773 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751055AbWCVVlV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 16:41:21 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLfLGt030465
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 16:41:21 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2MLiMOu187320
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:44:22 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2MLfKsP016892
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:41:20 -0700
Received: from hmsbounty.us.ibm.com (sig-9-76-215-94.mts.ibm.com [9.76.215.94])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLfKda016834
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:41:20 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches allow the aic94xx module to be unloaded and loaded.
All release functions in the sas transport and scsi core are being called
now. 

The patch to scsi_transport_sas most likely will need to be expanded as
there appears to be some extra puts in error cases, but this patch allows
the release functions to be called where they where not being called
before.

We have tested the patches on a single and multi-node x86 box and a ppc64
system.

We are currently investigating an issue on an expander based with drive
hotplug insertion.

-andmike
--
Michael Anderson
andmike@us.ibm.com
