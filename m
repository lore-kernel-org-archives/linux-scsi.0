From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] lpfc: Don't return internal MBXERR_ERROR code from probe function
Date: Fri, 15 Sep 2017 21:16:38 -0400
Message-ID: <yq14ls3tpc9.fsf@oracle.com>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
        <20170906110256.4445e353@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16490 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdIPBQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 21:16:54 -0400
In-Reply-To: <20170906110256.4445e353@elisabeth> (Stefano Brivio's message of
        "Wed, 6 Sep 2017 11:02:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>


Stefano,

> Internal error codes happen to be positive, thus the PCI driver
> core won't treat them as failure, but we do. This would cause a
> crash later on as lpfc_pci_remove_one() is called (e.g. as
> shutdown function).

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
