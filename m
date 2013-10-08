From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/3] target: EXTENDED_COPY bugfixes for v3.12-rc
Date: Tue,  8 Oct 2013 19:56:30 +0000
Message-ID: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57702 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHUNz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Oct 2013 16:13:55 -0400
Received: by mail-ob0-f170.google.com with SMTP id gq1so881987obb.29
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2013 13:13:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here are a few extra EXTENDED_COPY bugfixes that have come up recently.

This includes:

  - Reporting the correct ASC/ASCQ during target_do_xcopy() failures
  - Allow non zero list IDs to be processed as SNLID=1
  - Reject copy offload requests on source + destination devices when
    device attribute emulate_3pc has been explicitly disabled.

Thanks again to Thomas + Doug for their testing + feedback!

--nab

Nicholas Bellinger (3):
  target: Make target_do_xcopy failures return INVALID_PARAMETER_LIST
  target: Allow non zero ListID in EXTENDED_COPY parameter list
  target: Reject EXTENDED_COPY when emulate_3pc is disabled

 drivers/target/target_core_xcopy.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

-- 
1.7.10.4

