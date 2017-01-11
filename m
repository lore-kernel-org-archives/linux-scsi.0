From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] scsi: remove useless acpi functions in the head file
Date: Wed, 11 Jan 2017 10:30:15 +0800
Message-ID: <fa9e93f8-157e-b012-0e30-c621c505cc99@intel.com>
References: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
 <e1478c4b-28eb-a10b-f359-eab1f822271d@huawei.com>
 <2e748ead-9118-9a00-d9e7-711fc2cd85c3@intel.com>
 <58759557.7060405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58759557.7060405@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hanjun Guo <guohanjun@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On 01/11/2017 10:15 AM, Hanjun Guo wrote:
> On 2017/1/11 9:50, Aaron Lu wrote:
>> On 01/10/2017 07:44 PM, John Garry wrote:
>>> On 10/01/2017 08:14, Hanjun Guo wrote:
>>>> From: Hanjun Guo <hanjun.guo@linaro.org>
>>>>
>>>> commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
>>>> removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
>>>> but forgot to remove them in the head file, do it now.
>>>>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> Reviewed-by: Aaron Lu <aaron.lu@intel.com>
>>
>> Just out of curiosity, did you find this by some tool? If so, can you
>> please let me know the tool name so that I can avoid such problems in
>> the future? Thanks.
> 
> No, not found by tool. I was working on a patch set which tried to
> introduce a new acpi bus type [1], so I greped the usage of
> "struct acpi_bus_type" then found this issue :)

I see, thanks for the cleanup.

Regards,
Aaron
