From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/3] little bit of love to scsi_io_completion
Date: Mon, 04 Jan 2010 14:11:09 +0200
Message-ID: <4B41DADD.4000102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:19764 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994Ab0ADMLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 07:11:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.k>


Three small incremental patches to clean up scsi_io_completion and friends.
There should be absolutely no functional change after this patchset, only
readability improvements.

This patchset should open up the stage for the fixes Alan needs and farther
enhancements.

(Mike, Hannes, I know you have pending work here, please point me to patches and
 I'll rebase them for you)

List of patches
[PATCH 1/3] scsi_lib: request_queue is only needed inside scsi_requeue_command
[PATCH 2/3] scsi_lib: Remove that __scsi_release_buffers contraption
[PATCH 3/3] scsi_lib: Collapse scsi_end_request into only user

Are on top of scsi-misc Please consider for inclusion
Boaz

