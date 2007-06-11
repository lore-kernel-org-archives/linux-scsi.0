From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: scsi_debug fault-injection question
Date: Mon, 11 Jun 2007 09:42:07 -0700
Message-ID: <20070611094207.168a7664.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:59089 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXFKQmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 12:42:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: dgilbert@interlog.com

Hi Doug,

scsi_debug.c says:

MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");

I don't see where the default of 100 is set.

#define DEF_EVERY_NTH   0
...
static int scsi_debug_every_nth = DEF_EVERY_NTH;


Can you clarify for me, please?

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
