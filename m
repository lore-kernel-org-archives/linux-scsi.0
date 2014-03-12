From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v15 3/3] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Wed, 12 Mar 2014 09:32:13 -0700
Message-ID: <CAPw-ZT=xX9fi6zV8QFmCDAB7dvoLXSh+s1y_k9G0c44ONRbBOg@mail.gmail.com>
References: <1394059489-30706-1-git-send-email-lho@apm.com>
	<1394059489-30706-2-git-send-email-lho@apm.com>
	<1394059489-30706-3-git-send-email-lho@apm.com>
	<1394059489-30706-4-git-send-email-lho@apm.com>
	<20140311124943.GD11477@htj.dyndns.org>
	<CAPw-ZTmBSeOXv5ExVAiSkcU=qH3zHp52eVuGBfYYD=7=sjhVgw@mail.gmail.com>
	<20140311165548.GA20776@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140311165548.GA20776@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> Kishon didn't applied the PHY DTS patch. Did you first apply the PHY
>> DTS patch? We agreed that you will first pull in the PHY DTS as well
>> as the host controller patches. I don't see any reason why it wouldn't
>> apply if both DTS is applied. I will pull libata/for-3.15 and check
>> out.
>
> Can you please repost patches to apply on top of the current
> libata/for-3.15?
>

I posted v16 yetersday with the PHY DTS merged into the SATA host patches.

-Loc
