From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Remove usage of 'struct timeval'
Date: Fri, 15 Apr 2016 11:43:10 -0600
Message-ID: <624c2d8b5746488ce5587db59b613c51@mail.gmail.com>
References: <20160413070140.GA35235@localhost> <yq1inzjsi2v.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37883 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbcDORnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 13:43:12 -0400
Received: by mail-ig0-f175.google.com with SMTP id g8so29286426igr.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 10:43:12 -0700 (PDT)
In-Reply-To: <yq1inzjsi2v.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, suganath-prabu.subramani@avagotech.com, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Hi,
Please consider this patch as Ack-by: Sathya Prakash
<sathya.prakash@broadcom.com>

Thanks,
Sathya

-----Original Message-----
From: mpt-fusionlinux.pdl@broadcom.com
[mailto:mpt-fusionlinux.pdl@broadcom.com] On Behalf Of Martin K. Petersen
Sent: Thursday, April 14, 2016 8:48 PM
To: Tina Ruchandani
Cc: MPT-FusionLinux.pdl@broadcom.com; Arnd Bergmann;
y2038@lists.linaro.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; jejb@linux.vnet.ibm.com;
suganath-prabu.subramani@avagotech.com; Chaitra P B; Sreekanth Reddy
Subject: Re: [PATCH] mpt3sas: Remove usage of 'struct timeval'

>>>>> "Tina" == Tina Ruchandani <ruchandani.tina@gmail.com> writes:

Tina> 'struct timeval' will have its tv_sec value overflow on 32-bit
Tina> systems in year 2038 and beyond. This patch replaces the use of
Tina> struct timeval for computing mpi_request.TimeStamp, and instead
Tina> uses ktime_t which provides 64-bit seconds value. The timestamp
Tina> computed remains unaffected (milliseconds since Unix epoch).

Broadcom folks, please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
