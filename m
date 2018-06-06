From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V5] scsi: hpsa: disable device during shutdown
Date: Tue, 05 Jun 2018 21:19:57 -0400
Message-ID: <yq1d0x4g18i.fsf@oracle.com>
References: <1527913733-16492-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1527913733-16492-1-git-send-email-okaya@codeaurora.org> (Sinan
 Kaya's message of "Sat, 2 Jun 2018 00:28:53 -0400")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: ryan@finnie.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER hpsa" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, timur@codeaurora.org, "open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER hpsa" <esc.storagedev@microsemi.com>, open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Sinan,

> 'Commit cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during
> shutdown")' has been added to kernel to shutdown pending PCIe port
> service interrupts during reboot so that a newly started kexec kernel
> wouldn't observe pending interrupts.
>
> pcie_port_device_remove() is disabling the root port and switches by
> calling pci_disable_device() after all PCIe service drivers are shutdown.
>
> This has been found to cause crashes on HP DL360 Gen9 machines during
> reboot due to hpsa driver not clearing the bus master bit during the
> shutdown procedure by calling pci_disable_device().
>
> Disable device as part of the shutdown sequence.

Applied to 4.18/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
