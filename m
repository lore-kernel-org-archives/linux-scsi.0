From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
Date: Mon, 13 Apr 2015 15:38:47 +0530
Message-ID: <bc4eb5dffe342f41aa5e9dba5afe3d95@mail.gmail.com>
References: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com> <yq11tjvil9g.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36496 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbbDMKIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 06:08:50 -0400
Received: by qku63 with SMTP id 63so171953312qku.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 03:08:48 -0700 (PDT)
In-Reply-To: <yq11tjvil9g.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>Sent: Wednesday, April 08, 2015 4:45 AM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
>
>>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:
>
>Sumit> This patch has code optimization and refactoring in below areas-
>Sumit> 1) Created separate functions for sysPD IOs and non Read Write
>Sumit> LDIOs.  2) Added function for refiring MFI commands in controller
>Sumit> reset path.  3) Enabling interrupt immediately after adapter's
>Sumit> initialization.  4) Added function for setting up IRQs.  5)
>Sumit> Modified few prints for better logging.  6) Modified few macros
>Sumit> not to pass unused parameters.  7) Move internal commands and
>Sumit> SCSI commands reservation in adapter's sepcific functions.
>
>This needs to be 7 patches and not 1.
Ok, I will spilt this patch in 7 patches. Do you have any
feedback/comments for other patches of this series? IF you are ok with
other patches, I will resend the series with patch#1 splitted in 7 patches
and rest of the patches(2,3,4 and 5) will remain unchanged.
>
>--
>Martin K. Petersen	Oracle Linux Engineering
