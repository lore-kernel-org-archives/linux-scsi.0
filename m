From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/8] megaraid_sas: Send SYNCHRONIZE_CACHE for non-raid to firmware
Date: Mon, 24 Oct 2016 21:33:36 -0400
Message-ID: <yq1oa299pqn.fsf@sermon.lab.mkp.net>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
        <1477056816-7058-5-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50276 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932479AbcJYBdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 21:33:45 -0400
In-Reply-To: <1477056816-7058-5-git-send-email-kashyap.desai@broadcom.com>
        (Kashyap Desai's message of "Fri, 21 Oct 2016 06:33:32 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, stable@vger.kernel.org

>>>>> "Kashyap" == Kashyap Desai <kashyap.desai@broadcom.com> writes:

Kashyap> Commit- " 02b01e0 [SCSI] megaraid_sas: return sync cache call
Kashyap> with success" added the code in driver to return
Kashyap> SYNCHRONIZE_CACHE without sending it to firmware back in
Kashyap> 2007. Earlier MR was mainly for Virtual Disk, so same code
Kashyap> continue for JBOD as well whenever JBOD support was added and
Kashyap> it introduced bug that SYNCHRONIZE_CACHE is not passed to FW
Kashyap> for JBOD (non Raid disk).

Kashyap> But our recent analysis indicates that, From Day-1 MR Firmware
Kashyap> always expect Driver to forward SYNCHRONIZE_CACHE for JBOD (non
Kashyap> Raid disk) to the Firmware.  We have fixed this as part of this
Kashyap> patch.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
