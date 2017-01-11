From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: remove useless acpi functions in the header file
Date: Tue, 10 Jan 2017 23:08:31 -0500
Message-ID: <yq17f62s0g0.fsf@oracle.com>
References: <1484050603-5246-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484050603-5246-1-git-send-email-guohanjun@huawei.com> (Hanjun
        Guo's message of "Tue, 10 Jan 2017 20:16:43 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Hanjun Guo <guohanjun@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hanjun" == Hanjun Guo <guohanjun@huawei.com> writes:

Hanjun> From: Hanjun Guo <hanjun.guo@linaro.org> commit f1bc1e4c44b1
Hanjun> ("ata: acpi: rework the ata acpi bind support") removed
Hanjun> scsi_register_acpi_bus_type() and
Hanjun> scsi_unregister_acpi_bus_type(), but forgot to remove them in
Hanjun> the header file, do it now.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
