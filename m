From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH] cxl: remove dead Kconfig options
Date: Thu, 14 Jul 2016 12:05:08 +1000
Message-ID: <984bdc4c-1522-f166-c4c2-4f7e5b08909a@au1.ibm.com>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
 <yq1k2gpm0y0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5071 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750926AbcGNCFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2016 22:05:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6E24JYi134820
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2016 22:05:15 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
	by mx0b-001b2d01.pphosted.com with ESMTP id 2455fdmt1v-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2016 22:05:15 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Thu, 14 Jul 2016 12:05:12 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id D57642BB005B
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:05:09 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6E259Nj6684770
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:05:09 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6E258ZD027746
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:05:09 +1000
In-Reply-To: <yq1k2gpm0y0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linuxppc-dev@lists.ozlabs.org, imunsie@au1.ibm.com, mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, manoj@linux.vnet.ibm.com, clombard@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com

On 14/07/16 12:02, Martin K. Petersen wrote:
>>>>>> "Andrew" == Andrew Donnellan <andrew.donnellan@au1.ibm.com> writes:
>
> Andrew> Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they
> Andrew> were only needed to coordinate the merging of the cxlflash
> Andrew> driver. Also remove the stub implementation of
> Andrew> cxl_perst_reloads_same_image() in cxlflash which is only used if
> Andrew> CXL_EEH isn't defined (i.e. never).
>
> This patch straddles a few subsystems. Did you intend for me to queue it
> through SCSI?

Sorry for not stating explicitly - I'd like this taken through powerpc 
as the cxlflash change is incidental to the cxl changes.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

