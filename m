From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2] cxl: remove dead Kconfig options
Date: Mon, 18 Jul 2016 14:59:14 +1000
Message-ID: <14b26416-8ead-5329-13bb-078b6badd0cd@au1.ibm.com>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
 <1468817577-1843-1-git-send-email-andrew.donnellan@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45133 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbcGRE7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jul 2016 00:59:22 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6I4wNC8134437
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 00:59:21 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2481yfh40v-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 00:59:21 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Mon, 18 Jul 2016 14:59:18 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 867443578053
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:59:15 +1000 (EST)
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6I4xFG026017876
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:59:15 +1000
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
	by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6I4xEgX027823
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2016 14:59:15 +1000
In-Reply-To: <1468817577-1843-1-git-send-email-andrew.donnellan@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: clombard@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, mrochs@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, imunsie@au1.ibm.com

On 18/07/16 14:52, Andrew Donnellan wrote:
> Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they were only
> needed to coordinate the merging of the cxlflash driver. Also remove the
> stub implementation of cxl_perst_reloads_same_image() in cxlflash which is
> only used if CXL_EEH isn't defined (i.e. never).
>
> Suggested-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> Acked-by: Ian Munsie <imunsie@au1.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>
> ---
>
> Applies on top of powerpc#next, now that the Mellanox CX-4 patches have
> been applied.

As it turns out, this patch is exactly identical to V1... oh well.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

