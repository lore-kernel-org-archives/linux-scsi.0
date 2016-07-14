From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cxl: remove dead Kconfig options
Date: Wed, 13 Jul 2016 22:02:31 -0400
Message-ID: <yq1k2gpm0y0.fsf@sermon.lab.mkp.net>
References: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36476 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcGNCCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 22:02:45 -0400
In-Reply-To: <1467616334-20977-1-git-send-email-andrew.donnellan@au1.ibm.com>
	(Andrew Donnellan's message of "Mon, 4 Jul 2016 17:12:14 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, imunsie@au1.ibm.com, mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, manoj@linux.vnet.ibm.com, clombard@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com

>>>>> "Andrew" == Andrew Donnellan <andrew.donnellan@au1.ibm.com> writes:

Andrew> Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they
Andrew> were only needed to coordinate the merging of the cxlflash
Andrew> driver. Also remove the stub implementation of
Andrew> cxl_perst_reloads_same_image() in cxlflash which is only used if
Andrew> CXL_EEH isn't defined (i.e. never).

This patch straddles a few subsystems. Did you intend for me to queue it
through SCSI?

-- 
Martin K. Petersen	Oracle Linux Engineering
