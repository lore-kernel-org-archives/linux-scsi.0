From: Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] scsi: remove useless acpi functions in the head file
Date: Tue, 10 Jan 2017 20:17:14 +0800
Message-ID: <5874D0CA.1020703@huawei.com>
References: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
 <20170110115122.GB3721@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170110115122.GB3721@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On 2017/1/10 19:51, Johannes Thumshirn wrote:
> On Tue, Jan 10, 2017 at 04:14:04PM +0800, Hanjun Guo wrote:
>> From: Hanjun Guo <hanjun.guo@linaro.org>
>>
>> commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
>> removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
>> but forgot to remove them in the head file, do it now.
>                                    ^
> 				   header?

Yes, will update the patch.

>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
> Otherwise,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks!
Hanjun
