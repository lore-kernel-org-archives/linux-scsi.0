From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/16] aacraid: Use correct channel number for raw srb
Date: Wed, 15 Feb 2017 09:03:47 +0100
Message-ID: <d333c8b8-e0db-946d-ce08-3b2c0620ff96@suse.de>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170214204446.14808-3-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51583 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbdBOIDt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 03:03:49 -0500
In-Reply-To: <20170214204446.14808-3-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, dan.carpenter@oracle.com

On 02/14/2017 09:44 PM, Raghava Aditya Renukunta wrote:
> The channel being used for raw srb commands is retrieved from the utility
> sent fibs and is converted into physical channel id. The driver does not
> need to to do this since the management utility sends the correct channel
> id in the first place and in addition the driver sets inaccurate
> information in the cmd sent to the firmware and gets an invalid response.
> 
> Fixed by using channel id from srb command.
> 
> Cc: stable@vger.kernel.org
> Fixes: 423400e64d377c0 ("scsi: aacraid: Include HBA direct interface")
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
