From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Tue, 17 Sep 2013 07:54:43 -0400
Message-ID: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:62553 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765Ab3IQM0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:26:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest convenience.

These patches are on top of other qla4xxx patch posted on list here:
http://marc.info/?l=linux-scsi&m=137941920702034&w=2

Adheer Chandravanshi (7):
  qla4xxx: Correct the check for local CHAP entry type
  qla4xxx: Support setting of local CHAP index for flash target entry
  qla4xxx: Populate local CHAP credentials for flash target sessions
  qla4xxx: Use offset based on adapter type to set CHAP entry in flash
  scsi_transport_iscsi: Add support to set CHAP entries
  qla4xxx: Add support to set CHAP entries
  qla4xxx: Add support to get CHAP details for flash target session

Thanks,
Adheer

