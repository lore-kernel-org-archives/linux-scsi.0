From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Wed, 25 Jan 2017 18:28:20 -0500
Message-ID: <yq1tw8mbtyj.fsf@oracle.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
        <20170123163446.9227-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31830 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdAYX2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 18:28:43 -0500
In-Reply-To: <20170123163446.9227-2-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Mon, 23 Jan 2017 08:34:45 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Michael Hernandez <michael.hernandez@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> qla2x00_probe_one() allocates IRQs before it initializes rsp_q_map
Bart> so IRQs must be freed even if rsp_q_map allocation did not occur.
Bart> This was detected by kmemleak.

I queued this one yesterday but was waiting for a resolution on patch
2...

-- 
Martin K. Petersen	Oracle Linux Engineering
