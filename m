From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] vmw_pvscsi: handle the return value from pci_alloc_irq_vectors correctly
Date: Mon, 06 Mar 2017 22:27:57 -0500
Message-ID: <yq1y3whkbpe.fsf@oracle.com>
References: <20170303145716.19655-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:46500 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbdCGDtb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 22:49:31 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v273Tr5c030385
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 03:29:53 GMT
In-Reply-To: <20170303145716.19655-1-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 3 Mar 2017 07:57:16 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, loic.yhuel@gmail.com

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> It returns the number of vectors allocated when successful,
Christoph> so check for a negative error only.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
