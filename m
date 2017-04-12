From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: fix PCI error recovery path
Date: Tue, 11 Apr 2017 20:46:54 -0400
Message-ID: <yq1y3v6v4e9.fsf@oracle.com>
References: <20170406211209.27129-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27955 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdDLArD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 20:47:03 -0400
In-Reply-To: <20170406211209.27129-1-gpiccoli@linux.vnet.ibm.com> (Guilherme
        G. Piccoli's message of "Thu, 6 Apr 2017 18:12:09 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com

"Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com> writes:

> During a PCI error recovery, if aac_check_health() is not aware that
> a PCI error happened and we have an offline PCI channel, it might
> trigger some errors (like NULL pointer dereference) and inhibit the
> error recovery process to complete.
>
> This patch makes the health check procedure aware of PCI channel
> issues, and in case of error recovery process, the function
> aac_adapter_check_health() returns -1 and let the recovery process
> to complete successfully. This patch was tested on upstream kernel
> v4.11-rc5 in PowerPC ppc64le architecture with adapter 9005:028d
> (VID:DID) - the error recovery procedure was able to recover fine.

Applied to 4.11/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
