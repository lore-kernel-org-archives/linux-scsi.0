From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: RE: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Mon, 10 Nov 2014 18:07:13 +0000
Message-ID: <61a1781b-b67b-4cfa-ad05-aa57efe91874@CMEXHTCAS1.ad.emulex.com>
References: <84b5cd32-3bb6-4541-bbc1-4cbe92c074c6@CMEXHTCAS2.ad.emulex.com>
 <5460F7C2.6040205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:54047 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaKJSHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 13:07:50 -0500
In-Reply-To: <5460F7C2.6040205@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

>Adding Vikas to verify if qla4xxx has the same issue.

>On 11/10/2014 12:52 AM, Minh Duc Tran wrote:
>> From: Minh Tran minhduc.tran@emulex.com 
>> <mailto:minhduc.tran@emulex.com>
>> 
>>                We are starting to see problems with certain open-iscsi 
>> versions out there checking block valid bit.  Iscsi boot target login 
>> will not happen without this bit being set.
>> 

>What versions of open-iscsi? Is it just the SUSE based versions?

Yes, it's just the new SUSE open-iscsi for now.

>I think we want to move SYSFS_FLAG_FW_SEL_BOOT from ql4_def.h to include/linux/iscsi_boot_sysfs.h (also add a ISCSI_BOOT_ prefix), and then have both drivers use it.

