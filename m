From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 0/3] scsi_debug: review fixes for scsi-mq changes
Date: Tue, 05 Aug 2014 12:19:35 +0200
Message-ID: <53E0AFB7.1000304@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32785 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaHEKTj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 06:19:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

This series of patches is a result of feedback from the large
patch titled "[PATCH v2] scsi_debug: support scsi-mq, queues
and locks" sent to the list on 20140707. That patch is now in
Christoph's drivers-for-3.17 repository.

    1/3: scsi_cmnd->cmnd check and casts unnecessary
    2/3: give unit attention and other errors precedence over TSF
    3/3: bump inquiry version to SPC-4, update version descriptors

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
