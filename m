From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/16] aacraid: Skip wellness sync on controller failure
Date: Wed, 15 Feb 2017 09:35:30 +0100
Message-ID: <c4381802-8f1a-3f3a-fa83-0cc6d5d9cac1@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-9-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbdBOIfb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:35:31 -0500
In-Reply-To: <20170214204446.14808-9-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> aac_command_thread checks on the health of controller periodically,
> using aac_check_health. If the status is an error state KERNEL_PANIC or
> anything else. The driver will attempt to restart the adapter, but the
> response is not checked in aac_command_thread. This allows the periodic
> sync to go thru and lead the driver to a hung state.
> 
> Fixed by terminating the periodic loop(intended per original design),
> if the controller is not restored to a healthy state.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3d77d8404478353358 (scsi: aacraid: Added support for periodic wellness sync)
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Reviewed-by: David Carroll <David.Carroll@microsemi.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
