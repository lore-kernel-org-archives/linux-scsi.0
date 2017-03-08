From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 07 Mar 2017 20:29:51 -0500
Message-ID: <yq1d1dsimi8.fsf@oracle.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
        <yq1lgshkau0.fsf@oracle.com>
        <1488864262.2870.149.camel@kernel.crashing.org>
        <b7bac920-2ebe-a2fb-b775-c5a4381fe92e@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:32458 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbdCHC7i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 21:59:38 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v281VCdu017789
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2017 01:31:12 GMT
In-Reply-To: <b7bac920-2ebe-a2fb-b775-c5a4381fe92e@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Tue, 7 Mar 2017 09:51:14
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> I think I should have included this in the tested-by tag
Mauricio> email, for documentation/evidence: no regression observed in
Mauricio> system shutdown path.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
