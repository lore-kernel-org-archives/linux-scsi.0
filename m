From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 6 Mar 2017 11:52:36 -0300
Message-ID: <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60523 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752779AbdCFOwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 09:52:51 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v26EhZxk033362
        for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2017 09:52:50 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2917mtxxhj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2017 09:52:50 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 6 Mar 2017 11:52:48 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id E45483520072
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2017 09:52:12 -0500 (EST)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v26Eqkhn33161396
        for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2017 11:52:46 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v26EqjV7006680
        for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2017 11:52:46 -0300
In-Reply-To: <20170212214920.28866-1-anton@ozlabs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, benh@kernel.crashing.org, jk@ozlabs.org
Cc: linux-scsi@vger.kernel.org

On 02/12/2017 07:49 PM, Anton Blanchard wrote:
> We see lpfc devices regularly fail during kexec. Fix this by adding
> a shutdown method which mirrors the remove method.

Reviewed-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Tested-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

@mkp, @jejb: may you please flag this patch for stable?  Thank you.

This patch fixes a problem of some adapter ports going offline after
reboot on the following adapter, at least:

     [10df:f100] Saturn-X: LightPulse Fibre Channel Host Adapter

     # dmesg | grep lpfc
     ...
     [   61.676728] lpfc 0003:12:00.0: 6:0442 Adapter failed to init,
     mbxCmd x88 CONFIG_PORT, mbxStatus x0 Data: x0
     [   92.766717] lpfc 0003:12:00.0: 6:0442 Adapter failed to init,
     mbxCmd x88 CONFIG_PORT, mbxStatus x0 Data: x0
     [  123.856717] lpfc 0003:12:00.0: 6:0442 Adapter failed to init,
     mbxCmd x88 CONFIG_PORT, mbxStatus x0 Data: x0
     ...

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
