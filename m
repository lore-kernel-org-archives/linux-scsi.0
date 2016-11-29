From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Replace pci_pool_alloc by pci_pool_zalloc
Date: Tue, 29 Nov 2016 11:59:50 -0500
Message-ID: <yq1shqamdbt.fsf@sermon.lab.mkp.net>
References: <20161128095237.GA30900@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33540 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756797AbcK2RAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 12:00:01 -0500
In-Reply-To: <20161128095237.GA30900@gnr743-HP-ZBook-15> (Souptick Joarder's
        message of "Mon, 28 Nov 2016 15:22:37 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com
Cc: Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org

>>>>> "Souptick" == Souptick Joarder <jrdr.linux@gmail.com> writes:

Souptick> In lpfc_new_scsi_buf_s3() and lpfc_new_scsi_buf_s4()
Souptick> pci_pool_alloc followed by memset will be replaced by
Souptick> pci_pool_zalloc()

James, Dick: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
