From: Luben Tuikov <luben@splentec.com>
Subject: Q: eh_abort_handler and Task Management
Date: Tue, 29 Oct 2002 02:45:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBE3C92.964AA3C0@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9T7jMf27491
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2002 02:45:22 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Wouldn't it make sense to stupulate that the eh_abort_handler()
should NOT call scsi_done() for the command (even with DID_ABORT)?

This behaviour would be consistent with SAM-3 Task Management,
in that when aborted no response should be returned.

-- 
Luben
