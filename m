From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv6 0/8] SCSI EH cleanup
Date: Thu, 6 Apr 2017 19:52:40 +0200
Message-ID: <20170406175240.GB31571@bblock-ThinkPad-W530>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752198AbdDFRws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 13:52:48 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v36HmTgX027237
        for <linux-scsi@vger.kernel.org>; Thu, 6 Apr 2017 13:52:47 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29ntd7044u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2017 13:52:47 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Thu, 6 Apr 2017 18:52:45 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v36Hqhar12124454
        for <linux-scsi@vger.kernel.org>; Thu, 6 Apr 2017 17:52:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8801011C06F
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2017 18:52:05 +0100 (BST)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E0BB11C058
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2017 18:52:05 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.197])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2017 18:52:05 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <1491485796-44411-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

I really would have liked a stable-tag and -send for patches 1 and 2
(both Medium Access Timeout fixes). I think I or at least Steffen also
asked for that.

We saw several real-life occurrences with this bug and I think that
would have qualified for stable just fine.



                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
