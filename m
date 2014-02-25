From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v13 3/3] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Mon, 24 Feb 2014 22:08:57 -0800
Message-ID: <CAPw-ZTmM0G4-RXBMwxCXh32v8WpEv94A5+QdsQs40tmBy6DRkQ@mail.gmail.com>
References: <1393221265-13057-1-git-send-email-lho@apm.com>
	<1393221265-13057-2-git-send-email-lho@apm.com>
	<1393221265-13057-3-git-send-email-lho@apm.com>
	<1393221265-13057-4-git-send-email-lho@apm.com>
	<20140224183218.GB2522@htj.dyndns.org>
	<CAPw-ZT=CNdGn_iPp+jJbymvgBTNpXe1nCLeNwPWBdD3AAnHE6A@mail.gmail.com>
	<530C302A.5070809@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:45413 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751520AbaBYGI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2014 01:08:59 -0500
Received: by mail-qg0-f49.google.com with SMTP id j107so17781230qga.8
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2014 22:08:58 -0800 (PST)
In-Reply-To: <530C302A.5070809@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi Kishon/Tejun,

>>     > Signed-off-by: Loc Ho <lho@apm.com <mailto:lho@apm.com>>
>>     > Signed-off-by: Tuan Phan <tphan@apm.com <mailto:tphan@apm.com>>
>>     > Signed-off-by: Suman Tripathi <stripathi@apm.com <mailto:stripathi@apm.com>>
>>
>>     This doesn't apply cleanly to libata/for-3.15.  How should this be
>>     routed?
>>
>>
>> You need to apply the corresponding PHY driver as well. Are you taken the
>> corresponding PHY driver into your libata tree? If not, we will need to route
>> to Kishon generic PHY framework tree. I include Kishon Vijay Abraham to this
>> email thread.
>
> I prefer dt entry go via dt maintainer. However I can add my Acked-by for the
> dt patches if you can copy me in those patches.

The dt email is cc'ed in the patch. Do I need to do anything more here?

>> Kishon,
>>
>> Do I need to re-send my SATA PHY driver to you as I had being posting them to
>> the scsi/arm mailing list?
>
> Yes please.

Okay... I will re-post the PHY to you and linux-kernel@vger.kernel.org.

-Loc
