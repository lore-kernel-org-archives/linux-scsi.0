From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: scsi_dh_alua: allow I/O in target port
 unavailable and standby states
Date: Tue, 11 Jul 2017 18:01:31 -0300
Message-ID: <b8aca0c2-04a0-3573-34a1-3511831965d6@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1499726857-7875-2-git-send-email-mauricfo@linux.vnet.ibm.com>
 <b6e97d03-0e1b-df2a-70e2-3247833f3aac@suse.de>
 <224d8cd3-478c-2440-3479-0119885575cf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933156AbdGKVBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 17:01:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6BKwttZ005216
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 17:01:48 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bn0mxfak0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 17:01:47 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 11 Jul 2017 18:01:44 -0300
In-Reply-To: <224d8cd3-478c-2440-3479-0119885575cf@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/11/2017 12:32 PM, Mauricio Faria de Oliveira wrote:
> Also, it seems the Unavailable/Standby states would not be logged
> without a recheck from alua_check_sense(), since the only callers
> of alua_rtpg_queue() are alua_activate() and alua_check[_sense]()

Well, actually it does get logged if when activating/switching path
groups but shouldn't be the case with only a single path group.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
