From: Len Brown <len.brown@intel.com>
Subject: Re: problems with ACPI on 2.4.28-rc1
Date: 03 Nov 2004 18:47:44 -0500
Message-ID: <1099525664.13840.363.camel@d845pe>
References: <20041103223308.GA3588@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261991AbUKCXzx@vger.kernel.org>
In-Reply-To: <20041103223308.GA3588@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2004-11-03 at 17:33, mike.miller@hp.com wrote:
> Hello,
> Can anyone assist with this problem? I'm seeing a hang very early in
> boot under both 2.4.27 & 2.4.28-rc1.
> When the kernel begins to execute the system hangs with ERROR: Invalid
> Checksum. This seems to be ACPI related. The HW is HP DL360G4. Any
> help is appreciated. Here is the console output:
> 

> Linux version 2.4.27 (root@orange-rh3u4) (gcc version 3.2.3 20030502
> (Red Hat Linux 3.2.3-46)) #1 SMP Wed Nov 3 14:40:24 CST 2004

> ACPI: RSDP (v002 HP                                        ) @
> 0x00000000000f4f20
>   >>> ERROR: Invalid checksum
> Intel MultiProcessor Specification v1.4
>     Virtual Wire compatibility mode.
> OEM ID: HP       Product ID: PROLIANT     APIC at: 0xFEE00000

try booting with acpi=off (disabling ACPI in the kernel in 2.4 will not
really address this one b/c CONFIG_ACPI_BOOT will still be enabled
since you've got CONFIG_SMP)

Also, try installing the latest BIOS.

-len
