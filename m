From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 05/15] aacraid: Fix memory leak in fib init path
Date: Fri, 17 Feb 2017 09:22:29 +0100
Message-ID: <2470eadc-1808-f887-328e-55fb6067d22a@suse.de>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170216205124.20271-6-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbdBQIWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:22:31 -0500
In-Reply-To: <20170216205124.20271-6-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/16/2017 09:51 PM, Raghava Aditya Renukunta wrote:
> aac_fib_map_free frees misaligned fib dma memory, additionally it does not
> free up the whole memory.
> 
> Fixed by changing the  code to free up the correct and full memory
> allocation.
> 
> Cc: stable@vger.kernel.org
> Fixes: e8b12f0fb835223 ([SCSI] aacraid: Add new code for PMC-Sierra's SRC based controller family)
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> 
> ---
> Changes in V2:
> Refactored memory free code to make it easier to understand


Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
