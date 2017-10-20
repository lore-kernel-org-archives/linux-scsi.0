From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: [PATCH 0/1] qla2xxx: Fix oops in qla2x00_probe_one error path
Date: Fri, 20 Oct 2017 08:17:21 -0500
Message-ID: <1508505442-30352-1-git-send-email-dougmill@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45530 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751772AbdJTNRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 09:17:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9KDHF1n000730
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2017 09:17:30 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dqe5q3gp7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2017 09:17:29 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Fri, 20 Oct 2017 09:17:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com

See [PATCH 1/1] qla2xxx: Fix oops in qla2x00_probe_one error path
