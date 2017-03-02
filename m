From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6] sd: Check for unaligned partial completion
Date: Wed, 01 Mar 2017 21:48:01 -0500
Message-ID: <yq1poi0qtr2.fsf@oracle.com>
References: <20170301082700.20413-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:17845 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdCBCtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 21:49:20 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v222nEAV031776
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2017 02:49:14 GMT
In-Reply-To: <20170301082700.20413-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 1 Mar 2017 17:27:00 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien,

Damien> Move the partial completion alignement check of mpt3sas to a
Damien> generic implementation in sd_done(). The check is added within
Damien> the default section of the initial req_op() switch case so that
Damien> the report and reset zone commands are ignored. In addition, as
Damien> sd_done() is not called for passthrough requests, resid
Damien> corrections are not done as intended by the initial mpt3sas
Damien> patch.

Thanks! Applied to 4.11/scsi-fixes with a Cc: to stable.

-- 
Martin K. Petersen	Oracle Linux Engineering
