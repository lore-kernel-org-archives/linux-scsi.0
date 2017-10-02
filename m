From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V6 08/14] scsi: sd_zbc: Limit zone write locking to
 sequential zones
Date: Mon, 2 Oct 2017 17:00:17 +0000
Message-ID: <1506963616.3368.38.camel@wdc.com>
References: <20171002071535.8007-1-damien.lemoal@wdc.com>
         <20171002071535.8007-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5157 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdJBRAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 13:00:20 -0400
In-Reply-To: <20171002071535.8007-9-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <3D4BA0FF174E0549A6F0B1A972C10AC8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTEwLTAyIGF0IDE2OjE1ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gKwkgKiBUaGVyZSBpcyBubyB3cml0ZSBjb25zdHJhaW50cyBvbiBjb252ZW50aW9uYWwgem9u
ZXMuIFNvIGFueSB3cml0ZQ0KICAgICAgICAgICAgICAgICBeXg0KICAgICAgICAgICAgICAgICBh
cmU/DQoNCkFueXdheToNCg0KUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8QmFydC5WYW5B
c3NjaGVAd2RjLmNvbT4NCg==
