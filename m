From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: ufs: tc-dwc-g210: make arrays static, reduces
 object code size
Date: Tue, 12 Sep 2017 15:10:54 +0000
Message-ID: <1505229053.2537.0.camel@wdc.com>
References: <20170912113228.1389-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50907 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdILPLu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2017 11:11:50 -0400
In-Reply-To: <20170912113228.1389-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <5734B7B391F6EC4992B6A69A1AAB5A3D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "colin.king@canonical.com" <colin.king@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jpinto@synopsys.com" <jpinto@synopsys.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

T24gVHVlLCAyMDE3LTA5LTEyIGF0IDEyOjMyICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gRG9u
J3QgcG9wdWxhdGUgY29uc3QgYXJyYXlzIG9uIHRoZSBzdGFjaywgaW5zdGVhZCBtYWtlIHRoZW0N
Cj4gc3RhdGljLiAgTWFrZXMgdGhlIG9iamVjdCBjb2RlIHNtYWxsZXIgYnkgb3ZlciA3NDAgYnl0
ZXMuDQo+IA0KPiBCZWZvcmU6DQo+ICAgIHRleHQJICAgZGF0YQkgICAgYnNzCSAgICBkZWMJICAg
IGhleAlmaWxlbmFtZQ0KPiAgICAzODQwCSAgICAyMDgJICAgICAgMAkgICA0MDQ4CSAgICBmZDAJ
ZHJpdmVycy9zY3NpL3Vmcy90Yy1kd2MtZzIxMC5vDQo+IA0KPiBBZnRlcjoNCj4gICAgdGV4dAkg
ICBkYXRhCSAgICBic3MJICAgIGRlYwkgICAgaGV4CWZpbGVuYW1lDQo+ICAgIDI2NzkJICAgIDYy
NAkgICAgICAwCSAgIDMzMDMJICAgIGNlNwlkcml2ZXJzL3Njc2kvdWZzL3RjLWR3Yy1nMjEwLm8N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNh
bC5jb20+DQoNClBsZWFzZSBDQyB0aGUgbW9zdCBhY3RpdmUgY29udHJpYnV0b3JzIG9mIGEgZHJp
dmVyIHdoZW4gc3VibWl0dGluZyBhIGRyaXZlcg0KcGF0Y2guIEFueXdheToNCg0KUmV2aWV3ZWQt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAd2RjLmNvbT4=
