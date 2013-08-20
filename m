From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SCSI core patches for kernel 3.12
Date: Tue, 20 Aug 2013 09:11:31 -0700
Message-ID: <1377015091.5302.47.camel@haakon3.risingtidesystems.com>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59474 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3HTQEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 12:04:45 -0400
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-08-20 at 14:05 +0200, Bart Van Assche wrote:
> This patch series consists of four patches that address device removal 
> issues and three patches that improve performance of the SCSI mid-layer.
> 

Perhaps it would be useful to know what the performance improvement
actually is..?  Eg: fio numbers before and after.

Other than that, patch #7 to drop the unnecessary get_device ->
put_device is nice.  I've been intentionally leaving this overhead out
of scsi-mq thus far, and it's useful to know that this extra case
(according to this series) is not even required.

--nab 

> The individual patches are.
> 0001-Introduce-scsi_device_being_removed.patch
> 0002-Rework-scsi_internal_device_unblock.patch
> 0003-Avoid-re-enabling-I-O-after-the-transport-became-off.patch
> 0004-Disallow-changing-the-device-state-via-sysfs-into-de.patch
> 0005-Micro-optimize-scsi_request_fn.patch
> 0006-Rename-scsi_get_command-and-scsi_put_command.patch
> 0007-Micro-optimize-scsi_next_command.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


