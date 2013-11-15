From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY
 driver binding documentation
Date: Fri, 15 Nov 2013 12:52:17 -0800
Message-ID: <CAPw-ZTmDrxQYzMnF69TTOupy7uO94qo=3tr2X03GLpzqMusRxg@mail.gmail.com>
References: <1384457519-21335-1-git-send-email-lho@apm.com>
	<201311152054.10859.arnd@arndb.de>
	<CAPw-ZTmkP19O4jAhhPcWStEM+Cy_AtxUFPr_rhR6+6MRe_rXFQ@mail.gmail.com>
	<201311152119.55630.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201311152119.55630.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> >> It may be possible from ACPI point of view (hasn't tried yet). But for
>> >> DTS, there is no such firmware.
>> >
>> > Why not? Doesn't any boot loader have to initialize the hardware in order
>> > to load a kernel from disk?
>> [Loc Ho]
>> Not necessary for network booting, SD boot, and USB boot with ramdisk.
>
> But why not just initialize them all if you already have the boot loader
> contain all the drivers? There really isn't any difference between
> passing an ACPI blob or a DT blob to the kernel, as far as the boot loader
> is concerned.
>
[Loc Ho]
Yes... It is a possible solution. The draw back would be slow down the
boot loader. For now, let me implement the PHY for DTS and no PHY for
ACPI. From previous emails, it was discussed that PHY driver is
required for DTS. For ACPI, it is the responsible of the firmware.

-Loc
