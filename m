From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] ipr: Wait to do async scan until scsi host is initialized
Date: Wed, 27 Jul 2016 00:09:47 -0400
Message-ID: <yq18twn7md0.fsf@sermon.lab.mkp.net>
References: <20160715194804.89BFD2803D@b01ledav001.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbcG0EJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2016 00:09:57 -0400
In-Reply-To: <20160715194804.89BFD2803D@b01ledav001.gho.pok.ibm.com> (Brian
	King's message of "Fri, 15 Jul 2016 14:48:03 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> When performing an async scan, make sure the kthread doing
Brian> scanning doesn't start before the scsi host is fully initialized.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
