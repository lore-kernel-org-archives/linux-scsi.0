From: Bart Van Assche <bvanassche@acm.org>
Subject: SCSI core patches for kernel 3.12
Date: Tue, 20 Aug 2013 14:05:45 +0200
Message-ID: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:55146 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HTMFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 08:05:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

This patch series consists of four patches that address device removal 
issues and three patches that improve performance of the SCSI mid-layer.

The individual patches are.
0001-Introduce-scsi_device_being_removed.patch
0002-Rework-scsi_internal_device_unblock.patch
0003-Avoid-re-enabling-I-O-after-the-transport-became-off.patch
0004-Disallow-changing-the-device-state-via-sysfs-into-de.patch
0005-Micro-optimize-scsi_request_fn.patch
0006-Rename-scsi_get_command-and-scsi_put_command.patch
0007-Micro-optimize-scsi_next_command.patch

