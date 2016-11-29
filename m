From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] cciss: remove unneeded void pointer cast
Date: Tue, 29 Nov 2016 13:54:37 -0300
Message-ID: <12021f2a-ae68-db3d-6e22-c538da0e5889@osg.samsung.com>
References: <1476375042-10175-1-git-send-email-javier@osg.samsung.com>
 <4993A297653ECB4581FA5C3C31323D193B06FBC0@avsrvexchmbx1.microsemi.net>
 <71516d59-b181-d5b0-ead6-96e915846064@osg.samsung.com>
 <yq1bmwyp7ls.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46486
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753128AbcK2Qys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:54:48 -0500
In-Reply-To: <yq1bmwyp7ls.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello Martin,

On 11/29/2016 01:35 PM, Martin K. Petersen wrote:
>>>>>> "Javier" == Javier Martinez Canillas <javier@osg.samsung.com> writes:
> 
>>>> casting value returned by memory allocation function to (struct
>>>> cciss_scsi_adapter_data_t *) is useless.
>>>>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>
>>> Acked-by: Don Brace <don.brace@microsemi.com>
> 
> Javier> Thanks for the ack. Do you know who is supposed to pick this
> Javier> patch?
> 
> I'm happy to queue it. However, I never saw Don's ack and neither did
> patchwork. Was that done in a private email?
> 

Strange, it wasn't a private email but for some reason I see that it
didn't made it to neither LKML nor linux-scsi indeed. I was also not
able to find it in those archives.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
