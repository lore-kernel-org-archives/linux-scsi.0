From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Mon, 17 Sep 2012 11:15:43 -0700
Message-ID: <CC7CB653.20008%giridhar.malavali@qlogic.com>
References: <50571243.4050001@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <50571243.4050001@huawei.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org



On 9/17/12 5:06 AM, "Yijing Wang" <wangyijing@huawei.com> wrote:

>[  769.531289] qla2xxx [0000:08:00.0]-001d: : Found an ISP2532 irq 32
>iobase 0xffffc90016bcc000.
>[  769.531748] qla2xxx 0000:08:00.0: irq 91 for MSI/MSI-X
>[  769.531768] qla2xxx 0000:08:00.0: irq 92 for MSI/MSI-X
>[  799.503673] qla2xxx [0000:08:00.0]-d008:10: No buffer available for
>dump.
>[  799.503682] qla2xxx [0000:08:00.0]-101c:10: Mailbox cmd timeout
>occurred, cmd=0xb, mb[0]=0xb, eeh_busy=0x0. Scheduling ISP abort.
>[  799.503689] qla2xxx [0000:08:00.0]-0098:10: Failed to load segment 0
>of firmware.
>[  829.853242] qla2xxx [0000:08:00.0]-d008:10: No buffer available for
>dump.
>[  829.853249] qla2xxx [0000:08:00.0]-008f:10: Failed to load segment 0
>of firmware.
>[  829.853253] qla2xxx [0000:08:00.0]-00cf:10: Setup chip ****FAILED****.
>[  829.853258] qla2xxx [0000:08:00.0]-00d6:10: Failed to initialize
>adapter - Adapter flags 2.
>[  829.853893] qla2xxx 0000:08:00.1: enabling device (0104 -> 0106)
>[  829.855251] qla2xxx [0000:08:00.1]-001d: : Found an ISP2532 irq 42
>iobase 0xffffc90016b88000.
>[  829.855828] qla2xxx 0000:08:00.1: irq 91 for MSI/MSI-X
>[  829.855849] qla2xxx 0000:08:00.1: irq 92 for MSI/MSI-X
>[  859.827388] qla2xxx [0000:08:00.1]-d008:11: No buffer available for
>dump.
>[  859.827395] qla2xxx [0000:08:00.1]-101c:11: Mailbox cmd timeout
>occurred, cmd=0xb, mb[0]=0xb, eeh_busy=0x0. Scheduling ISP abort.
>[  859.827400] qla2xxx [0000:08:00.1]-0098:11: Failed to load segment 0
>of firmware.
>[  890.176829] qla2xxx [0000:08:00.1]-d008:11: No buffer available for
>dump.
>[  890.176837] qla2xxx [0000:08:00.1]-008f:11: Failed to load segment 0
>of firmware.
>[  890.176841] qla2xxx [0000:08:00.1]-00cf:11: Setup chip ****FAILED****.
>[  890.176845] qla2xxx [0000:08:00.1]-00d6:11: Failed to initialize
>adapter - Adapter flags 2.

I see that the one of the initial mailbox which loads data from system
memory to RISC RAM failing causing the probe to fail.

-- Giri
