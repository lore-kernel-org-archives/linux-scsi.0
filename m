From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 03/15] aacraid: Fix for excessive prints on EEH
Date: Fri, 17 Feb 2017 09:21:32 +0100
Message-ID: <f9ec8851-b2e9-1bdb-2578-c9fb68208cd0@suse.de>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170216205124.20271-4-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34563 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751822AbdBQIVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:21:35 -0500
In-Reply-To: <20170216205124.20271-4-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/16/2017 09:51 PM, Raghava Aditya Renukunta wrote:
> This issue showed up on a kdump debug(single CPU on powerkvm), when EEH
> errors rendered the adapter unusable. The driver correctly detected the
> issue and attempted to restart the controller, in doing so the driver
> attempted to read the status registers of the controller. This triggered
> additional eeh errors which continued for a good 6 minutes.
> 
> Fixed by returning without waiting when EEH error is reported.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> 
> ---
> Changes for V2:
> Refactored code to remove CONFIG_EEH macros


Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
