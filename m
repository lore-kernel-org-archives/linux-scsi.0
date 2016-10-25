From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/10]  mpt3sas driver Enhancements and
Date: Mon, 24 Oct 2016 21:17:40 -0400
Message-ID: <yq1shrl9qh7.fsf@sermon.lab.mkp.net>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 20 Oct 2016 17:50:08 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Suganath" == Suganath Prabu S <suganath-prabu.subramani@broadcom.com> writes:

Suganath,

Suganath> Here is the change list: Posting 10 patches for mpt3sas driver
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
Suganath>   * Updated driver version to 14.100.00.00

Please address the review comments, apply Hannes' review tags and
resubmit.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
