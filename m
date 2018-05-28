From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2] PCI/portdrv: do not disable device on reboot/shutdown
Date: Mon, 28 May 2018 14:25:33 -0700
Message-ID: <667a240c-9f83-181d-9aa3-f9ee3aa66272@codeaurora.org>
References: <1527043490-17268-1-git-send-email-okaya@codeaurora.org>
 <20180523213249.GD150632@bhelgaas-glaptop.roam.corp.google.com>
 <61f70fd6-52fd-da07-ce73-303f95132131@codeaurora.org>
 <82656e20-e821-1944-3399-1667ceb27719@codeaurora.org>
 <20180524130727.GA85822@bhelgaas-glaptop.roam.corp.google.com>
 <36b790d3fb4c43349cfa560283c03ab5@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <36b790d3fb4c43349cfa560283c03ab5@microsemi.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "ryan@finnie.org" <ryan@finnie.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Frederick Lawler <fred@fredlawl.com>, Dongdong Liu <liudongdong3@huawei.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsem>
List-Id: linux-scsi@vger.kernel.org

On 5/24/2018 6:37 AM, Don Brace wrote:
>> But we really need guidance from an hpsa expert.  I don't know the
>> filesystem/SCSI/hpsa details.
>>
>> Bjorn
> It's most likely OCSD traffic that will stop when bus mastering is turned off.
> So, I'll run some tests on my end before ACKing your patch.

Can you test V3 instead of this?

I don't think adding pci_disable_device() to shutdown() is enough to put
the HW into safe state. I moved clean  up responsibility to remove() instead
of shutdown().

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
