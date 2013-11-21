From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Thu, 21 Nov 2013 11:01:04 -0800
Message-ID: <CAPw-ZTnRbZid1Bzg6r62LjoEPRWpbDU7TAg=d=qVazEWVaUGjA@mail.gmail.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
	<201311151448.16279.arnd@arndb.de>
	<CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
	<201311211420.28509.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:54456 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754517Ab3KUTBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2013 14:01:05 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so162802pbb.31
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2013 11:01:04 -0800 (PST)
In-Reply-To: <201311211420.28509.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> >> diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
>> >> new file mode 100644
>> >> index 0000000..51e73f6
>> >> --- /dev/null
>> >> +++ b/drivers/ata/sata_xgene.h
>> >
>> > This file should probably just be folded into the driver, since it contains no
>> > interfaces between  modules, just internal definitions.
>> [Loc Ho]
>> I can get rip this header file now. But in the future I may need to
>> add this back as I intended this driver to also support running from
>> our co-processor (ARMv7 32-bit). For that, I will need anothe file and
>> other function that will need knowledge of the context structure and
>> etc.
>
> Hmm, is the code for that coprocessor compiled from the kernel source?
> If not, it shouldn't really make a difference as it won't live in a shared
> code repository.
>
[Loc Ho]
The co-processors are just ARM based core and the same kernel can be
build to support it. Let's not worry about this yet.

-Loc
