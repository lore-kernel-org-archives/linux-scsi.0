From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v15 3/3] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Tue, 11 Mar 2014 08:51:37 -0700
Message-ID: <CAPw-ZTmBSeOXv5ExVAiSkcU=qH3zHp52eVuGBfYYD=7=sjhVgw@mail.gmail.com>
References: <1394059489-30706-1-git-send-email-lho@apm.com>
	<1394059489-30706-2-git-send-email-lho@apm.com>
	<1394059489-30706-3-git-send-email-lho@apm.com>
	<1394059489-30706-4-git-send-email-lho@apm.com>
	<20140311124943.GD11477@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140311124943.GD11477@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

>> This patch adds APM X-Gene SoC AHCI SATA host controller DTS entries.
>
> I pulled the phy branch into libata/for-3.15 but this patch fails to
> apply.  Can you please regenerate the patches which need to be applied
> on top of libata/for-3.15.
>

Kishon didn't applied the PHY DTS patch. Did you first apply the PHY
DTS patch? We agreed that you will first pull in the PHY DTS as well
as the host controller patches. I don't see any reason why it wouldn't
apply if both DTS is applied. I will pull libata/for-3.15 and check
out.

-Loc
