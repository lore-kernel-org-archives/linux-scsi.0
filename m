From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] scsi support variable length commands
Date: Wed, 30 Apr 2008 11:13:15 +0300
Message-ID: <48182A1B.2060102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:35764 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbYD3IPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 04:15:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, matthieu castet <castet.matthieu@free.fr>

Now that large command support is in mainline this can go in.

Same old patches, with a few conflicts fixed. They are based on yesterdays
linux-block/for-linus + scsi-misc.

[PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd buffer
    new hunk here from new usb/storage/cypress_atacb.c

[PATCH 2/3] scsi: varlen extended and vendor-specific cdbs
[PATCH 3/3] iscsi_tcp: Enable any size command

Boaz
