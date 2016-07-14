From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH] cxl: remove dead Kconfig options
Date: Thu, 14 Jul 2016 12:07:32 +1000
Message-ID: <a67d8502-8b1c-e00d-106f-d223f7bddc63@au1.ibm.com>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
 <yq1k2gpm0y0.fsf@sermon.lab.mkp.net>
 <984bdc4c-1522-f166-c4c2-4f7e5b08909a@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17066 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbcGNCIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2016 22:08:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6E24NDP003055
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2016 22:08:16 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24539catpa-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2016 22:08:16 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Thu, 14 Jul 2016 12:08:12 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id A3E9A2CE8054
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:08:03 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6E283RF15532226
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:08:03 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6E282du002141
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 12:08:03 +1000
In-Reply-To: <984bdc4c-1522-f166-c4c2-4f7e5b08909a@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: clombard@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, mrochs@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org

On 14/07/16 12:05, Andrew Donnellan wrote:
> Sorry for not stating explicitly - I'd like this taken through powerpc
> as the cxlflash change is incidental to the cxl changes.

I'll also be submitting a v2 that applies on top of another cxl series 
that hasn't been merged yet.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

