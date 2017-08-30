From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/3] Call scsi_initialize_rq() also for filesystem
 requests
Date: Wed, 30 Aug 2017 21:13:00 +0000
Message-ID: <1504127579.2526.58.camel@wdc.com>
References: <20170830000742.29653-1-bart.vanassche@wdc.com>
         <20170830000742.29653-2-bart.vanassche@wdc.com>
         <20170830082928.GA17935@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:6656 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdH3VNs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 17:13:48 -0400
In-Reply-To: <20170830082928.GA17935@lst.de>
Content-Language: en-US
Content-ID: <7CC277F7C7C2CE42AE26E1B0D3F8F63E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTA4LTMwIGF0IDEwOjI5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gTG9va3MgZ29vZCBleGNlcHQgZm9yIHRoZSBzdWJqZWN0LCB3aGljaCB3aWxsIG5lZWQg
YSBsaXR0bGUgdXBkYXRlOg0KDQpIZWxsbyBDaHJpc3RvcGgsDQoNClRoYW5rcyBmb3IgdGhlIHJl
dmlldy4gU29ycnkgYnV0IEkgZG9uJ3Qgc2VlIHdoYXQncyB3cm9uZyB3aXRoIHRoZSBzdWJqZWN0
Lg0KQ2FuIHlvdSBjbGFyaWZ5IHlvdXIgY29tbWVudD8NCg0KQmFydC4=
