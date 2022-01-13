Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DB9C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jan 2022 14:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiAMOSV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jan 2022 09:18:21 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4411 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiAMOSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2022 09:18:20 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JZRNj1FkQz67wr8;
        Thu, 13 Jan 2022 22:18:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 15:18:18 +0100
Received: from [10.47.88.157] (10.47.88.157) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 13 Jan
 2022 14:18:17 +0000
Subject: Re: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
To:     <Ajish.Koshy@microchip.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
 <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
 <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
 <PH0PR11MB5112E3E9787F20EDEB58D481EC539@PH0PR11MB5112.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <05bec388-946d-057d-20d7-67ebe5f2cfdf@huawei.com>
Date:   Thu, 13 Jan 2022 14:17:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB5112E3E9787F20EDEB58D481EC539@PH0PR11MB5112.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.88.157]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/01/2022 12:52, Ajish.Koshy@microchip.com wrote:

Hi Ajish,

>>   From an earlier mail [0] I got the impression that you tested on an arm
>> platform – did you?
> Yes, with respect to my previous mail update, at that time got the chance to
> load the driver on ARM server/enclosure connected in one of our tester's
> arm server after attaching the controller card.
> There this error handling issue was observed.
> 
> The card/driver was never tested or validated on ARM server before,
> was curious to see the behavior for the first time. Whereas driver
> loads smoothly on x86 server.
> 
> Currently busy with some other issues, debugging on ARM server is not
> planned for now.
> 

OK, since you do see this same/similar issue with another card on arm 
then I think that it is safe to assume that it is a driver issue.

If you can share the dmesg on the arm machine then at least that would 
be helpful.

Thanks,
John
