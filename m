From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: fix an out of bound write
Date: Tue, 30 Jan 2018 21:12:02 -0500
Message-ID: <yq1a7wuhj4d.fsf@oracle.com>
References: <20180119152205.5461-1-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbeAaCMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 21:12:14 -0500
In-Reply-To: <20180119152205.5461-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 19 Jan 2018 16:22:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, hare@suse.de


Tomas,

> cpu_msix_table is allocated to store online cpus, but
> pci_irq_get_affinity may return cpu_possible_mask which is then used
> to access cpu_msix_table. That causes bad user experience.  Fix
> limits access to only online cpus, I've also added an additonal test
> to protect from an unlikely change in cpu_online_mask.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
