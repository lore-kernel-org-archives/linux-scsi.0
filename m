From: Luben Tuikov <luben@splentec.com>
Subject: Q: relationship between can_queue and cmd_per_lun?
Date: Fri, 21 Jun 2002 15:40:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D138128.C25C70D5@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g5LJeMP15239
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2002 15:40:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Is there any relationship between Scsi_Host::can_queue
and Scsi_Host::cmd_per_lun?

Given that there is only one device (one target
with a signle LUN) on a Scsi_Host, then what would
be the sense of can_queue=255 and cmd_per_lun=1?
(other than calling queuecommand() vs the older if.)

If there's a relationship, according to my understanding,
can_queue = LUN present * targets present * cmd_per_lun,
or the more general:
can_queue = \sum_Targets{\sum_Target_LUNS{cmd_per_This_LUN}}.

Can someone shed some light on this?

Also is there any way of finding the tagged queue depth,
other than tracking TASK SET FULL status code?

TIA,
-- 
Luben
