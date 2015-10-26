From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 05/32] scsi: hisi_sas: scan device tree
Date: Mon, 26 Oct 2015 14:51:23 +0000
Message-ID: <562E3DEB.1050603@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-6-git-send-email-john.garry@huawei.com>
 <20151026144854.GC12277@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151026144854.GC12277@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On 26/10/2015 14:48, Mark Rutland wrote:
>> +	sas_addr_prop = of_find_property(np, "sas-addr", NULL);
>> +	if (!sas_addr_prop || (sas_addr_prop->length != SAS_ADDR_SIZE))
>> +		goto err_out;
>> +	memcpy(hisi_hba->sas_addr, sas_addr_prop->value, SAS_ADDR_SIZE);
>
> This was not in the binding.
>
> What is this?
>
> Thanks,
> Mark.
>
> .
>
I had already noticed that this new property, "sas-addr", for patchset 
v2 had been omitted from the bindings file. I will add a comment to that 
patch.

John
