From: Rob Evers <revers@redhat.com>
Subject: [PATCH 0/3 V2] alua updates
Date: Fri, 18 May 2012 14:08:53 -0400
Message-ID: <1337364536-6425-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790Ab2ERSI5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2012 14:08:57 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4II8vZb009681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 May 2012 14:08:57 -0400
Received: from localhost (dhcp-185-85.bos.redhat.com [10.16.185.85])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4II8uLA016824
	for <linux-scsi@vger.kernel.org>; Fri, 18 May 2012 14:08:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A few minor updates to the previous alua patchset...

alua: retry alua rtpg extended header for illegal request response:
- Added entry condition to alua_rtpg ILLEGAL_REQUEST retry to avoid
  possible infinite loop. Infinte loop could occur if an array fails
  non-extended format rtpg request.

- Fixed a few comment typos

alua: backoff alua rtpg retry linearly vs. geometrically:
- Added Martin George's signoff on patch as he contributed this.

Rob Evers (3):
  alua: implement 'implied transition timeout'
  alua: retry alua rtpg extended header for illegal request response
  alua: backoff alua rtpg retry linearly vs. geometrically

 drivers/scsi/device_handler/scsi_dh_alua.c |   69 ++++++++++++++++++++++++----
 include/scsi/scsi.h                        |    2 +
 2 files changed, 62 insertions(+), 9 deletions(-)

-- 
1.7.7.2

