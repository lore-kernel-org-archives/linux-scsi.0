From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cciss: remove unneeded void pointer cast
Date: Tue, 29 Nov 2016 11:35:11 -0500
Message-ID: <yq1bmwyp7ls.fsf@sermon.lab.mkp.net>
References: <1476375042-10175-1-git-send-email-javier@osg.samsung.com>
        <4993A297653ECB4581FA5C3C31323D193B06FBC0@avsrvexchmbx1.microsemi.net>
        <71516d59-b181-d5b0-ead6-96e915846064@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50422 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754916AbcK2QfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:35:23 -0500
In-Reply-To: <71516d59-b181-d5b0-ead6-96e915846064@osg.samsung.com> (Javier
        Martinez Canillas's message of "Tue, 29 Nov 2016 11:46:47 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Don Brace <don.brace@microsemi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Javier" == Javier Martinez Canillas <javier@osg.samsung.com> writes:

>>> casting value returned by memory allocation function to (struct
>>> cciss_scsi_adapter_data_t *) is useless.
>>> 
>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> 
>> Acked-by: Don Brace <don.brace@microsemi.com>

Javier> Thanks for the ack. Do you know who is supposed to pick this
Javier> patch?

I'm happy to queue it. However, I never saw Don's ack and neither did
patchwork. Was that done in a private email?

-- 
Martin K. Petersen	Oracle Linux Engineering
