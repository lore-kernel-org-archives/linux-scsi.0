From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: remove useless acpi functions in the head file
Date: Tue, 10 Jan 2017 12:51:22 +0100
Message-ID: <20170110115122.GB3721@linux-x5ow.site>
References: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hanjun Guo <guohanjun@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 10, 2017 at 04:14:04PM +0800, Hanjun Guo wrote:
> From: Hanjun Guo <hanjun.guo@linaro.org>
> 
> commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
> removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
> but forgot to remove them in the head file, do it now.
                                   ^
				   header?
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
