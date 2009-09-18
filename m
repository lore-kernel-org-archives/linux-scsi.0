From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Final DIF/DIX patches for 2.6.32
Date: Fri, 18 Sep 2009 17:32:58 -0400
Message-ID: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:32140 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZIRVdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 17:33:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

James asked for a repost.  Only change is the cmd_len issue noticed by Boaz
last week.

Patches 1-3 are fixes and important.

Patches 4-5 add DIF Type 2 support.


