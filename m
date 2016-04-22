From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/4] pnp: pnpbios: Add explicit X86_32 dependency to
 PNPBIOS
Date: Sat, 23 Apr 2016 01:51:19 +0200
Message-ID: <571AB8F6.50802@intel.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <bbb2f28f39cbda8923eedca61bb5d9c55520f674.1460379702.git.vilhelm.gray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbcDVXvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2016 19:51:25 -0400
In-Reply-To: <bbb2f28f39cbda8923eedca61bb5d9c55520f674.1460379702.git.vilhelm.gray@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org

On 4/11/2016 3:25 PM, William Breathitt Gray wrote:
> The PNPBIOS driver requires preprocessor defines (located in
> include/asm/segment.h) only declared if the architecture is set to
> X86_32. If the architecture is set to X86_64, the PNPBIOS driver will
> not build properly. The X86 dependecy for the PNPBIOS configuration
> option is changed to an explicit X86_32	dependency in order to prevent
> an attempt to build for an unsupported architecture.
>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>

Has anyone taken care of this already?

If not, can you possibly resend this patch with a CC to 
linux-acpi@vger.kernel.org so I can pick it up via Patchwork more easily?

> ---
>   drivers/pnp/pnpbios/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
> index 50c3dd0..a786086 100644
> --- a/drivers/pnp/pnpbios/Kconfig
> +++ b/drivers/pnp/pnpbios/Kconfig
> @@ -3,7 +3,7 @@
>   #
>   config PNPBIOS
>   	bool "Plug and Play BIOS support"
> -	depends on ISA && X86
> +	depends on ISA && X86_32
>   	default n
>   	---help---
>   	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS

