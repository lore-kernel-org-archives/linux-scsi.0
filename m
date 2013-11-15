From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Fri, 15 Nov 2013 20:54:10 +0100
Message-ID: <201311152054.10859.arnd@arndb.de>
References: <1384457519-21335-1-git-send-email-lho@apm.com> <201311152026.07433.arnd@arndb.de> <CAPw-ZTnyknFs2S5uZOH7RyAqcQrk7z=Ms0QfRGd-kQfYsw4+wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3KOTyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 14:54:16 -0500
In-Reply-To: <CAPw-ZTnyknFs2S5uZOH7RyAqcQrk7z=Ms0QfRGd-kQfYsw4+wQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Friday 15 November 2013, Loc Ho wrote:
> It may be possible from ACPI point of view (hasn't tried yet). But for
> DTS, there is no such firmware.

Why not? Doesn't any boot loader have to initialize the hardware in order
to load a kernel from disk?

> I will make the entry more friendly
> for DTS. For ACPI, I am thinking that the BIOS/Firmware will just
> initialize it. As long as the clock isn't reset, the value will be
> there. Let's agree on these:
> 
> 1. DTS - use more friendly name
> 2. ACPI - handled by the BIOS/Firmware

Make sense.

	Arnd
