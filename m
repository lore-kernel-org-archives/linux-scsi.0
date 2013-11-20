From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 2/4] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY
 driver binding documentation
Date: Wed, 20 Nov 2013 12:07:45 -0800
Message-ID: <CAPw-ZTnvbLRN1v6Oyhyf=zXBuiOZQquDs6qx8PzF3cX_GnPTGw@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-2-git-send-email-lho@apm.com>
	<1384905197-3566-3-git-send-email-lho@apm.com>
	<20131120094328.GS5914@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:39971 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755007Ab3KTUHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 15:07:46 -0500
Received: by mail-pa0-f42.google.com with SMTP id lj1so4676053pab.15
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 12:07:45 -0800 (PST)
In-Reply-To: <20131120094328.GS5914@e106331-lin.cambridge.arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

>> +- compatible         : Shall be "apm,xgene-ahci-phy" or
>> +                       "apm,xgene-ahci-phy2". The "apm,xgene-ahci-phy"
>> +                       describes an port shared with SGMII Ethernet port.
>> +                       The "apm,xgene-ahci-phy2" describes an port not
>> +                       shared with SGMII and the PLL located at another
>> +                       memory resource region.
>
> Is there not a better name available than "apm,xgene-ahci-phy2"?
[Loc Ho]
I will name it apm,xgene-ahci-phyx.

>> +- reg                        : First PHY memory resource
>> +                       Second separate PHY PLL clock memory resource if
>> +                       type "apm,xgene-ahci-phy2"
>
> Is ths PLL actually part of the PHY, or does it just feed the PHY?
[Loc Ho]
This is always the PLL clock macro in each IP. For the 3rd controller,
we require an extra clock macro and can NOT use the original clock
macro as it is not mux'ed with the SGMII port.

>
>> +- txeyetuning                : Manual control to fine tune the capture of the serial
>> +                       bit lines from the automatic calibrated position.
>> +                       Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
>> +                       Range from 0 to 0x7f. Default is 0xa.
>
> If you have a property for which the name consists of multiple words,
> split the words with '-'.
>
> What does this actually mean?
>
> What units are these values in?
>
> What effect do those values have?
[Loc Ho]
Will provide in next version.

>
>> +- txeyedirection     : Eye tuning manual control direction. 0 means sample
>> +                       data earlier than the nominal sampling point. 1 means
>> +                       sample data later than the nominal sampling point.
>> +                       Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
>> +                       Default is 0x0.
>
> Likewise, use '-'.
>
> s/than/then/ ?
[Loc Ho]
I believe that than is appropriate here a we are doing an comparison.

-Loc
