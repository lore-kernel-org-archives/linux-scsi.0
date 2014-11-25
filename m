From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 0/5] scsi_debug: switch to table based parser
Date: Mon, 24 Nov 2014 23:04:09 -0500
Message-ID: <5473FFB9.8070206@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54338 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaKYEEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:04:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This series of patches is in response to Hannes' comments
earlier today. He wanted the single large patch broken up.

Changes since v1:
    - break single big patch into 4 smaller ones and one less
      large
    - resync with drivers-for-3.19

Patches:
     [PATCH v2 1/5] pinpoint invalid field in sense data
     [PATCH v2 2/5] append inject error flags onto scsi_cmnd object
     [PATCH v2 3/5] add Capacity Changed Unit Attention
     [PATCH v2 4/5] change SCSI command parser to table driven
     [PATCH v2 5/5] Add Report supported opcodes+tmfs; Compare and write

Todo:
    - re-order teardown in scsi_debug_exit()
    - make sdebug_dev_info::stopped atomic (add to end of uas_bm ?)
    - review Rob Elliott's suggestions; look at speed ups
    - remove host_lock logic and make the host_lock option a dummy
    - update some mode page and VPD data to reflect more recent
      devices
    - changing remaining >> and << byte handling over to
      get/put_unaligned_be*()
    - set INFO field for COMPARE AND WRITE command MISCOMPAREs


Hannes also asked that XDWRITEREAD_10 be added to scsi.h . It has
been there for a while. I guess he meant something else.


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
