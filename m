From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] PM / sleep: Make lock/unlock_system_sleep() available
 to kernel modules
Date: Fri, 5 Jan 2018 23:32:19 +0000
Message-ID: <1515195138.3254.26.camel@wdc.com>
References: <20180105171909.11839-1-bart.vanassche@wdc.com>
         <20180105171909.11839-2-bart.vanassche@wdc.com>
         <CAJZ5v0igct51CSp6FB=s3OZyr5fKKMxvy=T7gg2L39=r72Jtbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54950 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753002AbeAEXcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 18:32:24 -0500
In-Reply-To: <CAJZ5v0igct51CSp6FB=s3OZyr5fKKMxvy=T7gg2L39=r72Jtbg@mail.gmail.com>
Content-Language: en-US
Content-ID: <5EA2362DA5C1DF4CA2D9EDBC86958D73@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "rafael@kernel.org" <rafael@kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "terraluna977@gmail.com" <terraluna977@gmail.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>

T24gU2F0LCAyMDE4LTAxLTA2IGF0IDAwOjAwICswMTAwLCBSYWZhZWwgSi4gV3lzb2NraSB3cm90
ZToNCj4gVGhlIGNoYW5nZXMgYXJlIGZpbmUgYnkgbWUsIGJ1dCBJIHJlYWxseSB3b3VsZCBwcmVm
ZXIgdGhlbSB0byBnbyBpbg0KPiB2aWEgdGhlIFBNIHRyZWUgd2hpY2ggSSBndWVzcyBtZWFucyB0
aGF0IHRoZSBzZWNvbmQgcGF0Y2ggd291bGQgbmVlZA0KPiB0byBnbyBpbiB0aGlzIHdheSB0b28u
DQoNCkhlbGxvIFJhZmFlbCwNCg0KSWYgSSBjYW4gZ2V0IGEgVGVzdGVkLWJ5IGZyb20gV29vZHkg
YW5kIGFuIEFja2VkLWJ5IGZyb20gTWFydGluIHRoZW4gSSBjYW4NCmRvIHRoYXQuDQoNClRoYW5r
cywNCg0KQmFydC4=
