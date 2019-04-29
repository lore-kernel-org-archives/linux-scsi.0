From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: [PATCH 02/21] megaraid_sas: Fix calculation of target ID
Date: Mon, 29 Apr 2019 20:07:43 +0530
Message-ID: <CAOHJnDt3NcyHvYAB1AWt4Z6CqOQz7CKQrNLQj+GoYK-JhJOhAQ@mail.gmail.com>
References: <1556271435-27252-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20190426130618.82E892067D@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190426130618.82E892067D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 26, 2019 at 6:36 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.0.9, v4.19.36, v4.14.113, v4.9.170, v4.4.178, v3.18.138.
>
> v5.0.9: Build OK!
> v4.19.36: Build OK!
> v4.14.113: Build OK!
> v4.9.170: Failed to apply! Possible dependencies:
>     15dd03811d99 ("scsi: megaraid_sas: NVME Interface detection and prop settings")
>     18103efcacee ("scsi: megaraid-sas: request irqs later")
>     2493c67e518c ("scsi: megaraid_sas: 128 MSIX Support")
>     45f4f2eb3da3 ("scsi: megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid Controllers")
>     69c337c0f8d7 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID 1/10 Writes")
>     96188a89cc6d ("scsi: megaraid_sas: NVME interface target prop added")
>     d0fc91d67c59 ("scsi: megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware")
>     d889344e4e59 ("scsi: megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid Controllers")
>     fad119b707f8 ("scsi: megaraid_sas: switch to pci_alloc_irq_vectors")
>     fdd84e2514b0 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and IO Coalescing")
>
> v4.4.178: Failed to apply! Possible dependencies:
>     15dd03811d99 ("scsi: megaraid_sas: NVME Interface detection and prop settings")
>     179ac14291a0 ("megaraid_sas: Reply Descriptor Post Queue (RDPQ) support")
>     18365b138508 ("megaraid_sas: Task management support")
>     2216c30523b0 ("megaraid_sas: Update device queue depth based on interface type")
>     2c048351c8e3 ("megaraid_sas: Syncing request flags macro names with firmware")
>     6d40afbc7d13 ("megaraid_sas: MFI IO timeout handling")
>     96188a89cc6d ("scsi: megaraid_sas: NVME interface target prop added")
>     d889344e4e59 ("scsi: megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid Controllers")
>
> v3.18.138: Failed to apply! Possible dependencies:
>     0b48d12d0365 ("megaraid_sas: Make PI enabled VD 8 byte DMA aligned")
>     0d5b47a724ba ("megaraid_sas: Expose TAPE drives unconditionally")
>     16b8528d2060 ("megaraid_sas: use raw_smp_processor_id()")
>     18365b138508 ("megaraid_sas: Task management support")
>     2216c30523b0 ("megaraid_sas: Update device queue depth based on interface type")
>     2be2a98845e6 ("megaraid_sas : Modify return value of megasas_issue_blocked_cmd() and wait_and_poll() to consider command status returned by firmware")
>     4026e9aac3ff ("megaraid_sas : Use Block layer tag support for internal command indexing")
>     4a5c814d9339 ("megaraid_sas : Add separate functions for building sysPD IOs and non RW LDIOs")
>     5765c5b8b38a ("megaraid_sas : Support for Avago's Single server High Availability product")
>     7497cde883b1 ("megaraid_sas: add support for secure JBOD")
>     8a232bb39917 ("megaraid_sas : add missing __iomem annotations")
>     96188a89cc6d ("scsi: megaraid_sas: NVME interface target prop added")
>     aed335eecf8f ("megaraid_sas: Make tape drives visible on PERC5 controllers")
>     d009b5760f57 ("megaraid_sas: online Firmware upgrade support for Extended VD feature")
>     da0dc9fb4e6b ("megaraid_sas: fix whitespace errors")
>
>
> How should we proceed with this patch?
>
Hi Sasha,
This patch is applicable for 4.11.x and later stable trees only.
I will send out a v2 of this patch with appropriate kernel version requirement
along with the -stable tag.

Thanks,
Shivasharan
> --
> Thanks,
> Sasha
