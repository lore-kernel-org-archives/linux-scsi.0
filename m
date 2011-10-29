From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v2/RESEND] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Sat, 29 Oct 2011 16:34:41 +0200
Message-ID: <4EAC0F01.5070404@mvista.com>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org> <20111024223008.GB3305@orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111024223008.GB3305@orbis-terrarum.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 25.10.2011 0:30, Robin H. Johnson wrote:

> In the OCZ RevoDrive3/zDrive R4 series, the "OCZ SuperScale Storage
> Controller" with "Virtualized Controller Architecture 2.0" really seems
> to be a Marvell 88SE9485 part, with OCZ firmware/BIOS.
>
> Developed and tested on OCZ RevoDrive3 120GB [PCI 1b85:1021]
>
> Should work on:
> - OCZ RevoDrive3 (2x SandForce 2281)
> - OCZ RevoDrive3 X2 (4x SandForce 2281)
> - OCZ zDrive R4 CM84 (4x SandForce 2281)
> - OCZ zDrive R4 CM88 (8x SandForce 2281)
> - OCZ zDrive R4 RM84 (4x SandForce 2582)
> - OCZ zDrive R4 RM88 (8x SandForce 2582)
>
> All of this because a friend recently bought a OCZ RevoDrive3 and was
> bitten by the lack of Linux support.
>
> Notes from testing:
> -------------------
> - SMART works.
> - VPD Device Identification is "OCZ-REVODRIVE3"
> - Thin provisioning/TRIM seems to be implemented as WRITE SAME UNMAP,
>    with deterministic (non-zero) read after TRIM, but I'm not sure if it
>    works 100% in my testing.
> - Some of the tuning in the firmware seems to ensure much better
>    performance when in a RAID0 setup than using the two devices
>    seperately.
>
> I have not tested booting from the SSD, because all of this was
> developed and tested remotely from the actual hardware.
>
> Signed-off-by: Robin H. Johnson<robbat2@gentoo.org>
> Thanks-To: Gordon Pritchard<gordp@sfu.ca>
[...]
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index ae96bbe..3fe46e9 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2868,3 +2868,5 @@
>
>   #define PCI_VENDOR_ID_XEN		0x5853
>   #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
> +
> +#define PCI_VENDOR_ID_OCZ		0x1b85

    The vendor ID macros in this file are sorted by the ID value (except 
Xen, it seems).

WBR. Sergei

