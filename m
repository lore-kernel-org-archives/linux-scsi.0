From: Srihari Vijayaraghavan <harisri@bigpond.com>
Subject: Re: 2.5.65 and cciss
Date: Wed, 26 Mar 2003 00:15:59 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303260015.59925.harisri@bigpond.com>
References: <20030321024743.GA2267@zuul.cca.cpqcorp.net> <200303242238.11095.harisri@bigpond.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200303242238.11095.harisri@bigpond.com>
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: linux-scsi@vger.kernel.org

Hello Steve,

On Monday 24 March 2003 22:38, Srihari Vijayaraghavan wrote:
> ...
> ACPI: RSDP (v000 COMPAQ                     ) @ 0x000f4f70
> ACPI: RSDT (v001 COMPAQ P29      00000.00002) @ 0x3fffa000
> ACPI: FADT (v001 COMPAQ P29      00000.00002) @ 0x3fffa040
> ACPI: MADT (v001 COMPAQ 00000083 00000.00002) @ 0x3fffa100
> ACPI: SPCR (v001 COMPAQ SPCRRBSU 00000.00001) @ 0x3fffa1c0
> ACPI: DSDT (v001 COMPAQ     DSDT 00000.00001) @ 0x00000000
> ACPI: BIOS passes blacklist
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)

Same issue even without ACPI support being enabled in the computer. I just 
wanted just to be sure ACPI isn't causing the trouble.

In a couple of days time I will have a chance to test it on 2.5.66 (or 
whatever is the latest on that day and hour :-), it's very nice to see 2.5.x 
is moving along very nice and very fast toward 2.6)
-- 
Hari
harisri@bigpond.com


