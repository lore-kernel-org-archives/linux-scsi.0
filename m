From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 0/18] megaraid_sas : Description Patch
Date: Wed, 6 May 2015 19:20:20 +0530
Message-ID: <c675727c298eb1251d2f75c0fba76acb@mail.gmail.com>
References: <201504231102.t3NB2AtG029060@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:34147 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbEFNuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 09:50:22 -0400
Received: by qgfi89 with SMTP id i89so4612958qgf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2015 06:50:21 -0700 (PDT)
In-Reply-To: <201504231102.t3NB2AtG029060@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

Most of these patches have been reviewed earlier and few are reworked
based on feedback received. Does anyone have further comments/feedback for
these patches?

Thanks,
Sumit

>-----Original Message-----
>From: Sumit.Saxena@avagotech.com [mailto:Sumit.Saxena@avagotech.com]
>Sent: Thursday, April 23, 2015 4:30 PM
>To: linux-scsi@vger.kernel.org
>Cc: thenzl@redhat.com; martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com;
>sumit.saxena@avagotech.com
>Subject: [PATCH v3 0/18] megaraid_sas : Description Patch
>
>These patches have accomodated comments/feedback received on last sent
>patch series.
>Please consider this patch series for next release.
>
>Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>
>---
>[PATCH v3 0/18] megaraid_sas : Description Patch.
>[PATCH v3 1/18] megaraid_sas : Add separate function for setting up IRQs.
>[PATCH v3 2/18] megaraid_sas : Add separate function for refiring MFI
>commands.
>[PATCH v3 3/18] megaraid_sas : Add separate functions for building sysPD
IOs
>and non RW LDIOs.
>[PATCH v3 4/18] megaraid_sas : Move controller's queue depth calculation
in
>adapter specific function.
>[PATCH v3 5/18] megaraid_sas : Enhanced few prints.
>[PATCH v3 6/18] megaraid_sas : Use Block layer tag support for internal
>command indexing.
>[PATCH v3 7/18] megaraid_sas : Modify driver's meta data to reflect
Avago.
>[PATCH v3 8/18] megaraid_sas : Add release date and update driver
version.
>[PATCH v3 9/18] megaraid_sas : Support for Avago's Single server High
>Availability product.
>[PATCH v3 10/18] megaraid_sas : megasas_complete_outstanding_ioctls() can
>be static.
>[PATCH v3 11/18] megaraid_sas : add missing __iomem annotations.
>[PATCH v3 12/18] megaraid_sas : add endianess annotations.
>[PATCH v3 13/18] megaraid_sas : add endianess conversions for all ones.
>[PATCH v3 14/18] megaraid_sas : move endianess conversion into caller of
>megasas_get_seq_num.
>[PATCH v3 15/18] megaraid_sas : bytewise or should be done on native
>endian variables.
>[PATCH v3 16/18] megaraid_sas : add missing byte swaps to the sriov code.
>[PATCH v3 17/18] megaraid_sas : fix megasas_fire_cmd_fusion calling
>convention.
>[PATCH v3 18/18] megaraid_sas : swap whole register in
>megasas_register_aen.
