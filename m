From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Mon, 06 Mar 2017 22:35:00 -0500
Message-ID: <yq1tw75kbdn.fsf@oracle.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
        <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:28599 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbdCGIQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 03:16:22 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v273ac1v001059
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 03:36:39 GMT
In-Reply-To: <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Fri, 3 Mar 2017 22:43:16
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio,

Mauricio> Please flag this patch for stable.

Mauricio> This patch resolves a serious problem on IBM Power systems at
Mauricio> least.

Both patches are already upstream so I can't tag them for stable. Either
you or James should mail stable@vger.kernel.org and request for the
patches to be queued up.

-- 
Martin K. Petersen	Oracle Linux Engineering
