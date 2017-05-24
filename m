From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: don't disable a not previously enabled PCI device
Date: Tue, 23 May 2017 22:37:10 -0400
Message-ID: <yq1zie3ugix.fsf@oracle.com>
References: <20170523145047.5020-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26468 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbdEXCh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 22:37:26 -0400
In-Reply-To: <20170523145047.5020-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 23 May 2017 16:50:47 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, himanshu.madhani@cavium.com


Johannes,

> When pci_enable_device() or pci_enable_device_mem() fail in
> qla2x00_probe_one() we bail out but do a call to
> pci_disable_device(). This causes the dev_WARN_ON() in
> pci_disable_device() to trigger, as the device wasn't enabled
> previously.
>
> So instead of taking the 'probe_out' error path we can directly return
> *iff* one of the pci_enable_device() calls fails.
>
> Additionally rename the 'probe_out' goto label's name to the more
> descriptive 'disable_device'.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: e315cd28b9ef ("[SCSI] qla2xxx: Code changes for qla data structure refactoring")

Himanshu/Quinn: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
