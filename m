Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB97CC352AA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 12:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AEF921855
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 12:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="bEe3phAd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfJAMSQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 08:18:16 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52492 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfJAMSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 08:18:16 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x91CI1aZ106156;
        Tue, 1 Oct 2019 07:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1569932281;
        bh=xse21JTAzQ8GU1Wu6CB2o+llOAUhXp4hV5WxhhhEmJk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bEe3phAdv8S8+ucek6mTI+4AS67Ezt72kzbjzMc1tTGTwbStGkMK4iNvdmcgALj+L
         bX5dSWIDOwY2YDdJC46Ec6VkRxxon8xdMa53fHxywPfnYi6vgkDPLbqWdm+7ygxKtm
         qKq7AgWx1MIxMORiDX6dUjgMgHmHxPtSUN0K/w7Y=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x91CI1Dw055642
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Oct 2019 07:18:01 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 1 Oct
 2019 07:18:00 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 1 Oct 2019 07:17:50 -0500
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x91CHuxU053240;
        Tue, 1 Oct 2019 07:17:57 -0500
Subject: Re: [PATCH 1/2] dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for
 TI UFS wrapper
To:     Rob Herring <robh@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <nsekhar@ti.com>
References: <20190918133921.25844-1-vigneshr@ti.com>
 <20190918133921.25844-2-vigneshr@ti.com> <20191001120826.GA4214@bogus>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <c3490572-8230-3e41-0916-097091386b21@ti.com>
Date:   Tue, 1 Oct 2019 17:48:30 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001120826.GA4214@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 01/10/19 5:38 PM, Rob Herring wrote:
> On Wed, Sep 18, 2019 at 07:09:20PM +0530, Vignesh Raghavendra wrote:
>> Add binding documentation of TI wrapper for Cadence UFS Controller.
>>
>> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
>> ---
>>  .../devicetree/bindings/ufs/ti,j721e-ufs.yaml | 45 +++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
>> new file mode 100644
>> index 000000000000..dabd7c795fbe
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
>> @@ -0,0 +1,45 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/ufs/ti,j721e-ufs.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: TI J721e UFS Host Controller Glue Driver
>> +
>> +maintainers:
>> +  - Vignesh Raghavendra <vigneshr@ti.com>
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - const: ti,j721e-ufs
>> +
>> +  reg:
>> +    maxItems: 1
>> +    description: address of TI UFS glue registers
>> +
>> +  clocks:
>> +    maxItems: 1
>> +    description: phandle to the M-PHY clock
>> +
>> +  power-domains:
>> +    maxItems: 1
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - clocks
>> +  - power-domains
>> +
>> +examples:
>> +  - |
>> +    ufs_wrapper: ufs-wrapper@4e80000 {
>> +       compatible = "ti,j721e-ufs";
>> +       reg = <0x0 0x4e80000 0x0 0x100>;
>> +       power-domains = <&k3_pds 277>;
>> +       clocks = <&k3_clks 277 1>;
>> +       assigned-clocks = <&k3_clks 277 1>;
>> +       assigned-clock-parents = <&k3_clks 277 4>;
>> +       #address-cells = <2>;
>> +       #size-cells = <2>;
> 
> Based on the driver you expect to have a child node here with the UFS 
> controller? You need to show that and have a schema for it.
> 

Yes, Cadence UFS controller node will be the child node. Its bindings
are documented at: Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
(which in turn refers to
Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt)

But they are not in .yaml yet. How would you suggest to reference that?
Or should I just write plain text DT binding doc given that subsystem is
not converted to yaml?

>> +    };
>> -- 
>> 2.23.0
>>

-- 
Regards
Vignesh
