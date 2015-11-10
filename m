From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/5] ipr: Add delay to ensure coherent dumps.
Date: Mon, 09 Nov 2015 19:34:19 -0500
Message-ID: <yq1bnb2wv3o.fsf@sermon.lab.mkp.net>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42701 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbKJAe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 19:34:26 -0500
In-Reply-To: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
	(Gabriel Krisman Bertazi's message of "Tue, 3 Nov 2015 16:26:06
	-0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

>>>>> "Gabriel" == Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

Gabriel> Add a holding pattern prior to collecting dump data, to wait
Gabriel> for the IOA indication that the Mailbox register is stable and
Gabriel> won't change without an explicit reset.  This ensures we'll be
Gabriel> collecting meaningful dump data, even when dumping right after
Gabriel> an adapter reset.

I have applied patches 1-5.

-- 
Martin K. Petersen	Oracle Linux Engineering
