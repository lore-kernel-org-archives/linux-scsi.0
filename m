From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH] cxl: remove dead Kconfig options
Date: Fri, 8 Jul 2016 17:06:59 +1000
Message-ID: <4fa2f6c6-c4a5-a11a-676d-643320d20b96@au1.ibm.com>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58173 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427AbcGHHHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 03:07:07 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u68748vm109079
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jul 2016 03:07:07 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
	by mx0b-001b2d01.pphosted.com with ESMTP id 2415xp93ws-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2016 03:07:06 -0400
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Fri, 8 Jul 2016 17:07:03 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 509FA2BB0059
	for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2016 17:07:01 +1000 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u68771eZ10223968
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jul 2016 17:07:01 +1000
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
	by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u68770Xx029366
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jul 2016 17:07:01 +1000
In-Reply-To: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: clombard@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, mrochs@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, imunsie@au1.ibm.com

On 04/07/16 17:12, Andrew Donnellan wrote:
> Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they were only
> needed to coordinate the merging of the cxlflash driver. Also remove the
> stub implementation of cxl_perst_reloads_same_image() in cxlflash which is
> only used if CXL_EEH isn't defined (i.e. never).
>
> Suggested-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
>
> ---
>
> Applies on top of powerpc#next

I'm going to rebase this on top of the current Mellanox CX-4 series shortly.


Andrew

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

