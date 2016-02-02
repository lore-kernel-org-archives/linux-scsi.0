From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: bnx2fc_eh_abort(): fix wrong return code.
Date: Mon, 01 Feb 2016 20:50:59 -0500
Message-ID: <yq1h9hrop6k.fsf@sermon.lab.mkp.net>
References: <1454339325-12579-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50025 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcBBBvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:51:07 -0500
In-Reply-To: <1454339325-12579-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Mon, 1 Feb 2016 16:08:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio> If the link is not ready, the bnx2fc_eh_abort() function
Maurizio> should return FAILED.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
