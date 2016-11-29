From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] cciss: remove unneeded void pointer cast
Date: Tue, 29 Nov 2016 11:46:47 -0300
Message-ID: <71516d59-b181-d5b0-ead6-96e915846064@osg.samsung.com>
References: <1476375042-10175-1-git-send-email-javier@osg.samsung.com>
 <4993A297653ECB4581FA5C3C31323D193B06FBC0@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4993A297653ECB4581FA5C3C31323D193B06FBC0@avsrvexchmbx1.microsemi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "esc.storagedev" <esc.storagedev@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Don,

On 10/13/2016 03:12 PM, Don Brace wrote:
>> -----Original Message-----
>> From: Javier Martinez Canillas [mailto:javier@osg.samsung.com]
>> Sent: Thursday, October 13, 2016 11:11 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Javier Martinez Canillas; esc.storagedev; iss_storagedev@hp.com; Don
>> Brace; linux-scsi@vger.kernel.org
>> Subject: [PATCH] cciss: remove unneeded void pointer cast
>>
>> EXTERNAL EMAIL
>>
>>
>> It's not necessary to cast the result of kmalloc, since void pointers are
>> promoted to any other type. This also fixes following coccinelle warning:
>>
>> casting value returned by memory allocation function to (struct
>> cciss_scsi_adapter_data_t *) is useless.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Acked-by: Don Brace <don.brace@microsemi.com>
>> ---

Thanks for the ack. Do you know who is supposed to pick this patch?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
