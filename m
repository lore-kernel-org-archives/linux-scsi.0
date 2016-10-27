From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/11] mpt3sas driver Enhancements and
Date: Wed, 26 Oct 2016 21:57:37 -0400
Message-ID: <yq11sz27dv2.fsf@sermon.lab.mkp.net>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36664 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcJ0B6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 21:58:18 -0400
In-Reply-To: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Wed, 26 Oct 2016 13:34:31 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

>>>>> "Suganath" == Suganath Prabu S <suganath-prabu.subramani@broadcom.com> writes:

Suganath> Here is the change list: Posting 11 patches for mpt3sas driver
Suganath> enhancements and few fixes.
Suganath>   * Added Device ID's for SAS35 devices and updated MPI
Suganath>     Header.
Suganath>   * Support "EEDP Escape flag" for SAS35 devices.
Suganath>   * fixed improper printk statement.
Suganath>   * Regardless of whether RDPQ disabled card is enumerated
Suganath>     first or RDPQ enabled card is enumerated first, MSIX
Suganath>     vectors depends on the cards capability.
Suganath>   * device_remove_in_progress bit check has been added in
Suganath>     IOCTL path. If bit is set, then IOCTL will be failed
Suganath>     printing failure message.
Suganath>   * Started using the Atomic Request Descriptors for
Suganath>     SAS35 devices.
Suganath>   * For SAS35 devices MSIX vectors are inceased to 128 from
Suganath>     96.
Suganath>   * Fixing Endianness issue.
Suganath>   * Updated driver version to 14.100.00.00 at the end of SAS3
Suganath>     changes and updated driver minor version to 14.101.00.00
Suganath>     after SAS35 changes.

Applied to 4.10/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
