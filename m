From: Greg KH <greg@kroah.com>
Subject: Re: [BACKPORT 4.14.y 0/8] candidates from spreadtrum 4.14 product
 kernel
Date: Tue, 26 Mar 2019 11:26:52 +0900
Message-ID: <20190326022652.GB19395@kroah.com>
References: <20190322161727.1153278-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190322161727.1153278-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org, Jingoo Han <jingoohan1@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, Kishon Vijay Abraham I <kishon@ti.com>, Sebastian Reichel <sre@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Thierry Reding <thierry.reding@gmail.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-pci@v
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 22, 2019 at 05:17:15PM +0100, Arnd Bergmann wrote:
> I took a scripted approach to look at some product kernels for patches
> backported into vendor kernels. This is a set of (mostly) bugfixes I found
> in Spreadtrum's linux-4.14 kernel that are missing in v4.14.107:
> 
> 83dc7e3dea76 scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1
> 099a95f3591a PCI: designware-ep: dw_pcie_ep_set_msi() should only set MMC bits
> 1cab826b30c6 PCI: designware-ep: Read-only registers need DBI_RO_WR_EN to be writable
> b330104fa76d PCI: endpoint: Use EPC's device in dma_alloc_coherent()/dma_free_coherent()
> 36d46cdb43ef rtc: Fix overflow when converting time64_t to rtc_time
> 1b5d43cfb697 sched/cpufreq/schedutil: Fix error path mutex unlock
> 5fb5caee92ba pwm-backlight: Enable/disable the PWM before/after LCD enable toggle.
> f25a646fbe20 power: supply: charger-manager: Fix incorrect return value
> 
> Only a small number of patches here, the vendor tree is fairly close to
> mainline. All commits apply cleanly through git-cherry-pick.

Thanks for these, now queued up to 4.14.y and a few other branches that
needed them.

greg k-h
