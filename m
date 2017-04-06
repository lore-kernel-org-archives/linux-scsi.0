From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Thu, 06 Apr 2017 12:58:09 -0400
Message-ID: <yq14ly1qxr2.fsf@oracle.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
        <yq1h94tgsvd.fsf@oracle.com> <20170331065527.GA3024@lst.de>
        <20170403145124.GA1743@chelsio.com> <20170404064614.GA9275@lst.de>
        <20170404081943.GA1665@chelsio.com> <20170405062656.GA26470@lst.de>
        <20170405153933.GA1912@chelsio.com> <20170406075858.GA32019@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46716 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932096AbdDFQ6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 12:58:17 -0400
In-Reply-To: <20170406075858.GA32019@lst.de> (Christoph Hellwig's message of
        "Thu, 6 Apr 2017 09:58:58 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Varun Prakash <varun@chelsio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> Ok, the version below simplify skip the function split entirely:

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
