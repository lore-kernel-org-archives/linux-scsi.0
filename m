Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B72DC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35EE61A19
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 00:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhCYAPF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:15:05 -0400
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:36279 "EHLO
        8.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbhCYAPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 20:15:03 -0400
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 20:15:02 EDT
Received: from player774.ha.ovh.net (unknown [10.109.146.175])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 1E5531FC177
        for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2021 22:46:58 +0100 (CET)
Received: from ai0.uk (host-92-7-103-66.as43234.net [92.7.103.66])
        (Authenticated sender: ash@ai0.uk)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id 368F91C7B46C5;
        Wed, 24 Mar 2021 21:46:53 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-98R002c8451615-4408-474f-92c3-dd969735d59a,
                    709C8AB8CE36D75EAFFFA631B5D7D35D8760AF8E) smtp.auth=ash@ai0.uk
X-OVh-ClientIp: 92.7.103.66
From:   "Ash Izat" <ash@ai0.uk>
To:     <Viswas.G@microchip.com>, <jinpu.wang@cloud.ionos.com>,
        <Ruksar.devadi@microchip.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>
References: <009d01d71cb1$3fbd5200$bf37f600$@ai0.uk> <CAMGffE=B9QRncb2UO3aCfbH9naYU6-pP_c6T3PuHNRKRpnkDJA@mail.gmail.com> <SN6PR11MB3488473F4D3CAEEBE583AB159D689@SN6PR11MB3488.namprd11.prod.outlook.com> <SN6PR11MB3488B82D4D39713C6AEE270F9D639@SN6PR11MB3488.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB3488B82D4D39713C6AEE270F9D639@SN6PR11MB3488.namprd11.prod.outlook.com>
Subject: RE: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after v5.10.0
Date:   Wed, 24 Mar 2021 21:46:51 -0000
Message-ID: <012c01d720f7$361de9e0$a259bda0$@ai0.uk>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIEZhkRl1DSEXCvKDGFO+KKzJoBugLdwgrCALmVbjUBf56YZqoQZ2jA
X-Ovh-Tracer-Id: 12921108808251466907
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudehfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvfhgjufffkfggtgfgofhtsehtqhhgtddvtdejnecuhfhrohhmpedftehshhcukfiirghtfdcuoegrshhhsegrihdtrdhukheqnecuggftrfgrthhtvghrnhepvedtudfhueeffeevfefguddugfeuheffudehvedtfeffvdfhtdeijeegfeehleeknecukfhppedtrddtrddtrddtpdelvddrjedruddtfedrieeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejgedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegrshhhsegrihdtrdhukhdprhgtphhtthhopehlihhnuhigqdhstghsihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Viswas,

Patch applied on top of 5.12-rc4 and it is working perfectly now.
Double checked and without the patch the issue is still present in 5.12-rc4.

Thank you very much for the prompt response.

Is there any chance this will be backported to longterm (5.10) once it is merged?

Cheers,

Ash Izat

> -----Original Message-----
> From: Viswas.G@microchip.com <Viswas.G@microchip.com>
> Sent: 24 March 2021 18:07
> To: jinpu.wang@cloud.ionos.com; ash@ai0.uk; Ruksar.devadi@microchip.com;
> Vasanthalakshmi.Tharmarajan@microchip.com
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after
> v5.10.0
> 
> Hi Ash,
> 
> Can you please try this patch ?
> 
> Regards,
> Viswas G


