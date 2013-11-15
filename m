From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Fri, 15 Nov 2013 21:19:55 +0100
Message-ID: <201311152119.55630.arnd@arndb.de>
References: <1384457519-21335-1-git-send-email-lho@apm.com> <201311152054.10859.arnd@arndb.de> <CAPw-ZTmkP19O4jAhhPcWStEM+Cy_AtxUFPr_rhR6+6MRe_rXFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KOUU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 15:20:29 -0500
In-Reply-To: <CAPw-ZTmkP19O4jAhhPcWStEM+Cy_AtxUFPr_rhR6+6MRe_rXFQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Friday 15 November 2013, Loc Ho wrote:
> Hi,
> 
> >> It may be possible from ACPI point of view (hasn't tried yet). But for
> >> DTS, there is no such firmware.
> >
> > Why not? Doesn't any boot loader have to initialize the hardware in order
> > to load a kernel from disk?
> [Loc Ho]
> Not necessary for network booting, SD boot, and USB boot with ramdisk.

But why not just initialize them all if you already have the boot loader
contain all the drivers? There really isn't any difference between
passing an ACPI blob or a DT blob to the kernel, as far as the boot loader
is concerned.

	Arnd
