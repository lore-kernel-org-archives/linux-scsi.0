From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd: fix potential NULL pointer dereference
 in ufshcd_config_vreg
Date: Wed, 22 Nov 2017 08:18:45 -0600
Message-ID: <fd650699-87a9-acd8-543b-b86064f04b84@embeddedor.com>
References: <20171120141229.GA2130@embeddedor.com>
 <yq1fu97klmc.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fu97klmc.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 11/21/2017 10:01 PM, Martin K. Petersen wrote:
> Gustavo A.,
>
>> _vreg_ is being dereferenced before it is null checked, hence there is a
>> potential null pointer dereference.
>>
>> Fix this by moving the pointer dereference after _vreg_ has been null
>> checked.
> Applied to 4.15/scsi-fixes, thank you!
>

Glad to help. :)

Thanks
--
Gustavo A. R. Silva
