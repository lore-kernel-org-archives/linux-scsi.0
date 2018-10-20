From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: Fix NULL pointer dereference
Date: Sat, 20 Oct 2018 08:34:52 +0200
Message-ID: <4d9b6fb7-b2c7-0f87-8b4a-da8c01f8e78d@embeddedor.com>
References: <20181018165939.GA26491@embeddedor.com>
 <yq1efclinah.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1efclinah.fsf@oracle.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 10/20/18 12:28 AM, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> There is a NULL pointer dereference in case *slot* happens to
>> be NULL at lines 1053 and 1878:
>>
>> struct hisi_sas_cq *cq =
>> 	&hisi_hba->cq[slot->dlvry_queue];
>>
>> Notice that *slot* is being NULL checked at lines 1057 and 1881:
>> if (slot), which implies it may be NULL.
>>
>> Fix this by placing the declaration and definition of variable cq,
>> which contains the pointer dereference slot->dlvry_queue, after
>> slot has been properly NULL checked.
> 
> Applied to 4.20/scsi-queue, thanks!
> 

Glad to help. :)

Thanks
--
Gustavo
