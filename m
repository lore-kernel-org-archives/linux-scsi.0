From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v15 3/3] arm64: Add APM X-Gene SoC AHCI SATA host
 controller DTS entries
Date: Tue, 11 Mar 2014 12:55:48 -0400
Message-ID: <20140311165548.GA20776@mtj.dyndns.org>
References: <1394059489-30706-1-git-send-email-lho@apm.com>
 <1394059489-30706-2-git-send-email-lho@apm.com>
 <1394059489-30706-3-git-send-email-lho@apm.com>
 <1394059489-30706-4-git-send-email-lho@apm.com>
 <20140311124943.GD11477@htj.dyndns.org>
 <CAPw-ZTmBSeOXv5ExVAiSkcU=qH3zHp52eVuGBfYYD=7=sjhVgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:57323 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaCKQzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2014 12:55:52 -0400
Content-Disposition: inline
In-Reply-To: <CAPw-ZTmBSeOXv5ExVAiSkcU=qH3zHp52eVuGBfYYD=7=sjhVgw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hello, Loc.

On Tue, Mar 11, 2014 at 08:51:37AM -0700, Loc Ho wrote:
> Kishon didn't applied the PHY DTS patch. Did you first apply the PHY
> DTS patch? We agreed that you will first pull in the PHY DTS as well
> as the host controller patches. I don't see any reason why it wouldn't
> apply if both DTS is applied. I will pull libata/for-3.15 and check
> out.

Can you please repost patches to apply on top of the current
libata/for-3.15?

Thanks.

-- 
tejun
