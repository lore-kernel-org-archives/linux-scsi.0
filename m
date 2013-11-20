From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 14:23:07 -0800
Message-ID: <CAPw-ZTmGvjyfgpiJy-9G26g5KDVmkYv85418H3RgCPCnq_0CTg@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-4-git-send-email-lho@apm.com>
	<20131120150658.GB28946@htj.dyndns.org>
	<201311201641.20230.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:36772 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146Ab3KTWXJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 17:23:09 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so4206905pab.36
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 14:23:08 -0800 (PST)
In-Reply-To: <201311201641.20230.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tejun Heo <tj@kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jon Masters <jcm@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Olof Johansson <olof@lixom.net>, Tuan Phan <tphan@apm.com>

Hi,

> On Wednesday 20 November 2013, Tejun Heo wrote:
>> On Tue, Nov 19, 2013 at 04:53:16PM -0700, Loc Ho wrote:
>> > This patch adds support for APM X-Gene SoC 6.0Gbps SATA PHY. This is the
>> > physical layer interface for the corresponding SATA host controller. This
>> > driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
>>
>> Hmm... this is related to ahci but isn't even a libata driver and is
>> the first such driver proposed.  Are we sure drivers/ata is the best
>> home for this?  Shouldn't we create a separate directory somewhere?
>> It's confusing, at least to me, to have non-libata driver under
>> drivers/ata.
>
> It needs to be in drivers/phy, which is currently being prepared for
> the next merge window and which contains the generic interface used
> in this driver.
[Loc Ho]
I will move it to drivers/phy. The PHY framework did make it to the
final release of 3.12.00.

-Loc
