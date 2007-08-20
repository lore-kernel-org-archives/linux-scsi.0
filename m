From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: more SCSI API doc. question
Date: Mon, 20 Aug 2007 12:34:36 -0700
Message-ID: <20070820123436.c3ba59e2.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:64432 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbXHTT3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 15:29:41 -0400
Received: from agmgw1.us.oracle.com (agmgw1.us.oracle.com [152.68.180.212])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l7KJTdKI018496
	for <linux-scsi@vger.kernel.org>; Mon, 20 Aug 2007 14:29:40 -0500
Received: from acsmt351.oracle.com (acsmt351.oracle.com [141.146.40.151])
	by agmgw1.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id l7KB3ipF026404
	for <linux-scsi@vger.kernel.org>; Mon, 20 Aug 2007 13:29:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


Where should other (undocumented) SCSI API docs be added?
I'll be glad to send updates/patches/


E.g.:

scsi_bufflen(cmnd)
scsi_sg_count(cmnd)
scsi_sglist(cmnd)
scsi_get_resid(cmnd)
scsi_set_resid(cmnd, int)

and all kernel-doc blocks from scsi_lib.c

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
