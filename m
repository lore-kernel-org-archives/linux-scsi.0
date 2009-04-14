From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/13] mpt2sas: driver version 01.100.02.00
Date: Mon, 13 Apr 2009 22:26:40 -0600
Message-ID: <20090414042637.GA20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og55.obsmtp.com ([64.18.14.175]:50395 "EHLO
	chip3og55.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZDNSAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:00:54 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI0nbo004197
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:00:49 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI0pxm014298
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:00:53 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is set of misc bug fix's, to include T10 DIF support, and Lun Reset
Support. Please consider for inclusion.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

[PATCH 1/13] mpt2sas: unique ioctl magic number
[PATCH 2/13] mpt2sas: the sanity check in base_interrupt needs to be on dword boundary
[PATCH 3/13] mpt2sas: fix oops when firmware sends large sense buffer size
[PATCH 4/13] mpt2sas: running out of message frames
[PATCH 5/13] mpt2sas: driver name needs to be in the MPT2IOCINFO ioctl
[PATCH 6/13] mpt2sas: Identify Dell series-7 adapters at driver load time.
[PATCH 7/13] mpt2sas: Broadcast Primative AEN bug fix
[PATCH 8/13] mpt2sas: release diagnostic buffers prior host reset
[PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
[PATCH 10/13] mpt2sas: LUN Reset Support
[PATCH 11/13] mpt2sas: add query task support for MPT2COMMAND  ioctl
[PATCH 12/13] mpt2sas: using the same naming convention for all static function
[PATCH 13/13] mpt2sas: bump driver version
