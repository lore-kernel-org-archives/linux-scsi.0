From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 07/22] scsi: hisi_sas: add the initialisation for
 pci-based controller
Date: Wed, 17 May 2017 14:33:52 +0200
Message-ID: <CAK8P3a1ML8=3WerLt1GNRD+4k4RtRQgW1AfNZhkf2qm_hyLfZw@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com> <1495018197-120535-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-8-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
> Add the code to initialise controller which is based on pci device
> in hisi_sas_pci_init.c
>
> The main functionality added is for probing and initialisation of
> the controller based on pci device.
>
> The core controller routines are still in hisi_sas_main.c; some
> common initialisation functions and structures are also exported from
> hisi_sas_main.c for pci init.
>
> For platform device-based controller, controller properties - like
> phy count - were read from the firmware. For pci-based controller this
> information is hard-coded in the driver, in new struct hisi_sas_pci_hw.
>

Do you plan to add further PCI based front-ends besides the v3 driver
in the future? If not, you can save one level of indirection here and merge
pci_init.c into the v3 implementation.

     Arnd
