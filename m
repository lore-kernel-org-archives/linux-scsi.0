From: Luben Tuikov <luben@splentec.com>
Subject: status as in SAM2
Date: Fri, 24 May 2002 11:11:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEE5837.CECADF71@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g4OEAvu15411
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2002 10:10:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello there.

Given SCpnt->result and that queuecommand() has
returned with error or done() was called,
how can I find out the status byte as per SAM2,
given SCpnt->result?

Is it just ``status_byte(SCpnt->result)''?
(macro defined in scsi.h)

TIA,
-- 
Luben
