From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/5] qla4xxx: Patches for scsi-misc
Date: Fri, 16 Dec 2011 01:58:54 -0800
Message-ID: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:45101
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1LPKNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Lalit Chandivade (1):
      qla4xxx: cleanup, make qla4xxx_build_ddb_list short

Manish Rangankar (1):
      qla4xxx: Fixed BFS with sendtargets as boot index.

Nilesh Javali (2):
      qla4xxx: Limit the ACB Default Timeout value to 12s
      qla4xxx: Break the loop if the sendtargets list was empty

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.02.00-k11

 drivers/scsi/qla4xxx/ql4_os.c      |  419 +++++++++++++++++++++--------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 2 files changed, 252 insertions(+), 169 deletions(-)

Thanks,
Vikas.

