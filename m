From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Some fixes to aacraid
Date: Fri, 17 Nov 2017 19:14:52 -0200
Message-ID: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754065AbdKQVSF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 16:18:05 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAHLI1jc075623
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:18:05 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ea4suq5td-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:18:03 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Fri, 17 Nov 2017 16:15:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org
Cc: gpiccoli@linux.vnet.ibm.com, david.carroll@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, gpiccoli@protonmail.ch

This series presents 3 small fixes for aacraid driver.
The most important is the crash prevention, IMHO.

Tested them against v4.14.

Guilherme G. Piccoli (3):
  scsi: aacraid: Check for PCI state of device in a generic way
  scsi: aacraid: Perform initialization reset only once
  scsi: aacraid: Prevent crash in case of free interrupt during scsi EH path

 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/commsup.c | 35 +++--------------------------------
 drivers/scsi/aacraid/linit.c   |  3 +++
 drivers/scsi/aacraid/rx.c      | 15 ++++++++++-----
 drivers/scsi/aacraid/src.c     | 20 ++++++++++++++------
 5 files changed, 31 insertions(+), 43 deletions(-)

-- 
2.15.0
