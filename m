From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Cleaned up comment references to @sdp argument explanation.
Date: Fri, 20 Jan 2017 16:59:39 -0500
Message-ID: <yq160l9ie9g.fsf@oracle.com>
References: <1484255840-29950-1-git-send-email-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35653 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdATV7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 16:59:46 -0500
In-Reply-To: <1484255840-29950-1-git-send-email-jpittman@redhat.com> (John
        Pittman's message of "Thu, 12 Jan 2017 16:17:20 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Pittman <jpittman@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "John" == John Pittman <jpittman@redhat.com> writes:

John> In sd.c there are two comment references to 'struct scsi_device
John> *sdp' as an argument.  One of the references has a typo and the
John> other should be a reference to 'struct device *dev' instead.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
