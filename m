From: seeteena <s1seetee@linux.vnet.ibm.com>
Subject: [PATCH] libsas: fix \"sysfs group not found\" warnings at port
 teardown time
Date: Wed, 11 Jan 2017 11:59:23 +0530
Message-ID: <a0be3adc-b9e9-86cc-773d-d209834183a9@linux.vnet.ibm.com>
References: <20150520220858.15073.8982.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751042AbdAKG3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 01:29:32 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v0B6TEah094433
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 01:29:31 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27w2xm5cr6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 01:29:31 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <s1seetee@linux.vnet.ibm.com>;
        Tue, 10 Jan 2017 23:29:30 -0700
In-Reply-To: <20150520220858.15073.8982.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com, linux-scsi@vger.kernel.org

Hi All,

Let me know if this patch is accepted in Upsteam? let me know the commit id

