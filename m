From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: don't disable a not previously enabled PCI device
Date: Wed, 24 May 2017 15:11:48 -0400
Message-ID: <yq1fufuul1n.fsf@oracle.com>
References: <20170523145047.5020-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170523145047.5020-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 23 May 2017 16:50:47 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org


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

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
