From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 0/3] ipr: Fixes for 4.2-rc
Date: Tue, 14 Jul 2015 11:41:25 -0500
Message-ID: <55A53BB5.2010009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:48225 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbGNQlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 12:41:31 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 14 Jul 2015 12:41:31 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5B27638C8052
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2015 12:41:28 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6EGfSfa61866012
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2015 16:41:28 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6EGfRKO008022
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2015 12:41:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

James,

Given the previous ipr driver update missed the 4.2 merge window, I'm resending the
three patches also critical enough for -stable. The first is a fix for an oops and
the other two are fixes for memory corruption bugs. If you've already queued these
up, you can ignore this resend, but I was hoping to get these into 4.2-rc due to
the nature of the bugs they fix. 

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


