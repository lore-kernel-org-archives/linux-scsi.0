From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2fc: replace printk() with BNX2FC_IO_DBG()
Date: Tue, 31 May 2016 22:45:50 -0400
Message-ID: <yq1zir5vd7l.fsf@sermon.lab.mkp.net>
References: <1464597661-6192-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbcFACqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 22:46:04 -0400
In-Reply-To: <1464597661-6192-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Mon, 30 May 2016 10:41:01 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: axboe@kernel.dk, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, loberman@redhat.com

>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:

Maurizio> The "fcp_rsp_code = %d" message isn't an error, it's meant to
Maurizio> be informative only.  This patch prevents a flood of such
Maurizio> messages in some situations.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
