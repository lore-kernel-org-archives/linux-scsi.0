From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] hpsa: remove coalescing settings for ioaccel2
Date: Tue, 31 Jan 2017 21:51:52 -0500
Message-ID: <yq1wpdazkqf.fsf@oracle.com>
References: <148581391749.10289.15802474685670424837.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39079 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdBACwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 21:52:51 -0500
In-Reply-To: <148581391749.10289.15802474685670424837.stgit@brunhilda> (Don
        Brace's message of "Mon, 30 Jan 2017 16:05:17 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> - Setting coalescing has a significant negative impact on low
Don> queue-depth performance.  - Does not help high queue-depth
Don> performance.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
