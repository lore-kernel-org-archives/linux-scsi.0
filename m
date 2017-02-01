From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] mpt3sas: Force request partial completion alignment
Date: Tue, 31 Jan 2017 22:34:11 -0500
Message-ID: <yq1bmumzirw.fsf@oracle.com>
References: <1485455821-9176-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48671 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbdBADeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 22:34:20 -0500
In-Reply-To: <1485455821-9176-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
        (Guilherme G. Piccoli's message of "Thu, 26 Jan 2017 16:37:01 -0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, brking@linux.vnet.ibm.com, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com, martin.petersen@oracle.com

>>>>> "Guilherme" == Guilherme G Piccoli <gpiccoli@linux.vnet.ibm.com> writes:

Guilherme> The firmware or device, possibly under a heavy I/O load, can
Guilherme> return on a partial unaligned boundary. Scsi-ml expects these
Guilherme> requests to be completed on an alignment boundary. Scsi-ml
Guilherme> blindly requeues the I/O without checking the alignment
Guilherme> boundary of the I/O request for the remaining bytes. This
Guilherme> leads to errors, since devices cannot perform non-aligned
Guilherme> read/write operations.

Guilherme> This patch fixes the issue in the driver. It aligns unaligned
Guilherme> completions of FS requests, by truncating them to the nearest
Guilherme> alignment boundary.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
