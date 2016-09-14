From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] hpsa updates
Date: Wed, 14 Sep 2016 14:22:39 -0400
Message-ID: <yq1poo6l4sw.fsf@sermon.lab.mkp.net>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25391 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753970AbcINSXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 14:23:18 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda> (Don
        Brace's message of "Fri, 9 Sep 2016 16:30:11 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> The following changes are based on Linus's tree:
Don>  - correct minor bug created when adding hpsa_skip_device
Don>  - add check for null devices do to configuration changes
Don>  - add check for null devices in ioaccel path
Don>  - add check for vpd support
Don>  - stop sending bmic commands to externals

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
