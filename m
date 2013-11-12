From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Tue, 12 Nov 2013 14:39:49 -0800
Message-ID: <CAPw-ZTnqQk5cEJKSn239m=v9A7KmL8iVPcVnHWgq1E1TRCJ+og@mail.gmail.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
	<201311110954.32904.arnd@arndb.de>
	<CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>
	<201311121411.54423.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:49689 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753391Ab3KLWju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 17:39:50 -0500
Received: by mail-pa0-f44.google.com with SMTP id hz1so3770165pad.17
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2013 14:39:49 -0800 (PST)
In-Reply-To: <201311121411.54423.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Tuan Phan <tphan@apm.com>

Hi Arnd,

I looked at the PHY generic framework and come across this statement
below. Our SATA PHY is embedded into the SoC. Should I ignore this
statement below and implement the PHY driver using this framework?

+This framework will be of use only to devices that use external PHY (PHY
+functionality is not embedded within the controller).

-Loc


On Tue, Nov 12, 2013 at 5:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 12 November 2013, Loc Ho wrote:
>> Hi Arnd/Olof,
>>
>> I looked over the phy code for USB and NET. There isn't such PHY
>> infrastructure for SATA from what I can tell. It seems like I will
>> need to put this all together. I am thinking about porting the USB
>> version over (with changes for SATA) and put it under
>> "./drivers/ata/phy". Any suggestion?
>
> Please have a look at the patches under the subject "Generic PHY Framework"
> posted by Kishon Vijay Abraham. I thought they would have made it in
> by now, but I have not followed the recent kernels closely since I am
> on parental leave at the moment.
>
> IIRC they should unify USB, SATA and other PHY codes, but not network.
>
>         Arnd
