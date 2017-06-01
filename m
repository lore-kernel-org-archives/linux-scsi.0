From: Raphael Philipe Mendes da Silva <raphasil@linux.vnet.ibm.com>
Subject: Re: [PATCH 10/15] lpfc: Fix crash on powering off BFS VM with
 passthrough device
Date: Thu, 1 Jun 2017 16:27:25 -0300
Message-ID: <a96ff6be-02c6-1a44-38c2-0f30fed937bc@linux.vnet.ibm.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
 <20170531060439.2073-11-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59217 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdFAT23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 15:28:29 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v51JO1L1134820
        for <linux-scsi@vger.kernel.org>; Thu, 1 Jun 2017 15:28:28 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2atmk4d9qd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 15:28:28 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <raphasil@linux.vnet.ibm.com>;
        Thu, 1 Jun 2017 16:28:25 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v51JSETC15007834
        for <linux-scsi@vger.kernel.org>; Thu, 1 Jun 2017 16:28:23 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v51JRoVs017800
        for <linux-scsi@vger.kernel.org>; Thu, 1 Jun 2017 16:27:51 -0300
In-Reply-To: <20170531060439.2073-11-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Answering to https://marc.info/?l=linux-scsi&m=149625285323719&w=2
Yes, it solves the error.

Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
