From: YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH -next] advansys: use correct srb_tag in adv_isr_callback
Date: Wed, 17 Oct 2018 20:03:41 +0800
Message-ID: <82ba2304-8dd8-5da6-29f3-40e5c878815a@huawei.com>
References: <20180926114107.13532-1-yuehaibing@huawei.com>
 <yq1murdpd9z.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1murdpd9z.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: matthew@wil.cx, hare@suse.com, jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 2018/10/17 9:34, Martin K. Petersen wrote:
> 
> Hi Yue Haibing,
> 
>>  	srb_tag = le32_to_cpu(scsiqp->srb_tag);
>> -	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);
>> +	scp = scsi_host_find_tag(boardp->shost, srb_tag);
> 
> Maybe I'm missing something, but I don't see where in the code
> scsiqp->srb_tag is being converted to le32. srb_tag is beyond the memory
> accessed by the controller and thus wouldn't need to be little endian.

Thanks for comment this.

So 'srb_tag' can been removed.

> 
