From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 1/6] scsi_error: count medium access timeout only once
 per EH run
Date: Mon, 13 Mar 2017 12:54:02 -0300
Message-ID: <2aa9cba5-07be-d166-990a-d73314d26a22@linux.vnet.ibm.com>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-2-git-send-email-hare@suse.de>
 <10894b48-b215-f2ef-6df0-d48a94ec7158@linux.vnet.ibm.com>
 <7d908388-cfff-3c02-c185-9a0ccbcd3d45@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752132AbdCMPyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 11:54:20 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2DFmx22040858
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 11:54:18 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 294c8xcap6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 11:54:18 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 13 Mar 2017 12:54:16 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2DFsEJ130146738
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 12:54:14 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2DFsDUx017685
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 12:54:14 -0300
In-Reply-To: <7d908388-cfff-3c02-c185-9a0ccbcd3d45@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

On 03/13/2017 11:48 AM, Hannes Reinecke wrote:
> This is assuming that we're always running on a scsi_disk, and that
> scsi_disk is the only one implementing 'eh_action'.
> Neither of which is necessarily true.

Ah, OK. Thanks for explaining.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
