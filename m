From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/16] aacraid: Reorder Adapter status check
Date: Wed, 15 Feb 2017 09:50:40 +0100
Message-ID: <6b15f7d8-5654-863b-afde-6899bdd5779e@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-14-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751067AbdBOIup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:50:45 -0500
In-Reply-To: <20170214204446.14808-14-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> The driver currently checks the SELF_TEST_FAILED first and then
> KERNEL_PANIC next. Under error conditions(boot code failure) both
> SELF_TEST_FAILED and KERNEL_PANIC can be set at the same time.
> 
> The driver has the capability to reset the controller on an KERNEL_PANIC
> , but not on SELF_TEST_FAILED.
> 
> Fixed by first checking KERNEL_PANIC and then the others.
> 
> Cc: stable@vger.kernel.org
> Fixes: e8b12f0fb835223752 ([SCSI] aacraid: Add new code for PMC-Sierra's SRC base controller family)
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---

Apart from the odd comma placement in the 2nd paragraph of the commit
message
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
