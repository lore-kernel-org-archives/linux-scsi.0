From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 0/2] csiostor : Add maintainer & code cleanup
Date: Thu, 10 Sep 2015 16:03:50 -0700
Message-ID: <1441926232-16091-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:32410 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035AbbIJXER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 19:04:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, hare@suse.de, hch@lst.de, praveenm@chelsio.com, hariprasad@chelsio.com, Anish Bhatt <anish@chelsio.com>

Patches adds Praveen Madhavan as maintainer for the csiostor driver
and cleans up dead code in the csiostor driver.

Applies on e56f698bd072 ('blk-mq: set default timeout as 30 seconds')
at hare/scsi-devel master

Anish Bhatt (2):
  scsi : Add maintainer for csiostor driver
  csiostor : Remove __CSIO_DEBUG__ dead code

 MAINTAINERS                        | 7 +++++++
 drivers/scsi/csiostor/csio_attr.c  | 2 +-
 drivers/scsi/csiostor/csio_defs.h  | 8 +-------
 drivers/scsi/csiostor/csio_hw.c    | 2 +-
 drivers/scsi/csiostor/csio_hw.h    | 6 +-----
 drivers/scsi/csiostor/csio_mb.c    | 2 +-
 drivers/scsi/csiostor/csio_rnode.c | 4 ++--
 drivers/scsi/csiostor/csio_scsi.c  | 2 --
 8 files changed, 14 insertions(+), 19 deletions(-)

-- 
2.5.1

