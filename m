From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/10] mpt2sas: bug fixes for 2.6.30
Date: Tue, 21 Apr 2009 15:36:36 -0600
Message-ID: <20090421213633.GA18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og61.obsmtp.com ([64.18.14.187]:50036 "EHLO
	chip3og61.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZDUVe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:34:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

misc bug fix's, please consider for 2.6.30

Signed-off-by: Eric Moore <eric.moore@lsi.com>

[PATCH 1/10] mpt2sas : unique ioctl magic number
[PATCH 2/10] mpt2sas : the sanity check in base_interrupt needs to be on dword boundary
[PATCH 3/10] mpt2sas : fix oops when firmware sends large sense buffer size
[PATCH 4/10] mpt2sas : running out of message frames
[PATCH 5/10] mpt2sas : driver name needs to be in the MPT2IOCINFO ioctl
[PATCH 6/10] mpt2sas : Identify Dell series-7 adapters at driver load time.
[PATCH 7/10] mpt2sas : Broadcast Primative AEN bug fix.
[PATCH 8/10] mpt2sas : release diagnotic buffers prior host reset
[PATCH 9/10] mpt2sas : mpt2sas: fix hotplug event processing
[PATCH 10/10] mpt2sas : bump driver version to 01.100.02.00
