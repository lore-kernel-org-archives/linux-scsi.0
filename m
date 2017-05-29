From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 07/22] scsi: hisi_sas: create hisi_sas_get_fw_info()
Date: Mon, 29 May 2017 13:22:55 +0200
Message-ID: <CAK8P3a03iCKbv6MZ0VZgZ21kP2+NHDBTXARAtGa-iPgLn1J2hg@mail.gmail.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
 <1495713911-80476-8-git-send-email-john.garry@huawei.com> <CAK8P3a1ySYpsa=sWo3xkXA7uBz_zYxfTecXMuX6C3d1HEg=qyg@mail.gmail.com>
 <25de582f-ad54-c30a-f0e5-6de54f04917f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25de582f-ad54-c30a-f0e5-6de54f04917f@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 29, 2017 at 1:18 PM, John Garry <john.garry@huawei.com> wrote:
> On 29/05/2017 11:53, Arnd Bergmann wrote:
>> On Thu, May 25, 2017 at 2:04 PM, John Garry <john.garry@huawei.com> wrote:
>
> So we only require these properties for platform device with DT firmware.
> This code is same as before (apart from adding the comments), but I'll
> consider adding a verbose comment.
>
> As for the check, effectively I already have what you recommend in how np is
> evaluated:
> +       struct platform_device *pdev = hisi_hba->platform_dev;
> +       struct device_node *np = pdev ? pdev->dev.of_node : NULL;
>         struct clk *refclk;

Ah, very good. Thanks for checking.

       Arnd
