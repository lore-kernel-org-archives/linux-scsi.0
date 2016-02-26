From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ipr: Fix regression when loading firmware
Date: Fri, 26 Feb 2016 17:26:45 -0500
Message-ID: <yq1vb5bf6qi.fsf@sermon.lab.mkp.net>
References: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30429 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbcBZW0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 17:26:55 -0500
In-Reply-To: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
	(Gabriel Krisman Bertazi's message of "Thu, 25 Feb 2016 13:54:20
	-0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, Insu Yun <wuninsu@gmail.com>

>>>>> "Gabriel" == Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

Gabriel> Commit d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite")
Gabriel> removed the end of line handling when storing the update_fw
Gabriel> sysfs attribute.  This changed the userpace API because it
Gabriel> started refusing writes terminated by a line feed, which broke
Gabriel> the update tools we already have.

Gabriel> This patch re-adds that handling, so both a write terminated by
Gabriel> a line feed or not can make it through with the update.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
