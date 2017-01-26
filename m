From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] Revert "sd: remove __data_len hack for WRITE SAME"
Date: Thu, 26 Jan 2017 10:01:39 -0700
Message-ID: <29a461aa-c4b0-eede-f1ba-b5f6215b7824@fb.com>
References: <48f53712-569e-d5c3-7269-d0eeb481f8ee@sandisk.com>
 <20170125222015.GA1422@lst.de> <yq1r33qa5r7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42027 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753946AbdAZRCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 12:02:11 -0500
In-Reply-To: <yq1r33qa5r7.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/25/2017 07:56 PM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> Thanks Bart, and sorry for messing this up.  Acked-by:
> Christoph> Christoph Hellwig <hch@lst.de>
> 
> Jens: Since this came in via your tree would you mind reverting it? I'd
> prefer to avoid rebasing my fixes branch.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Yep, I have added it, thanks.

-- 
Jens Axboe

