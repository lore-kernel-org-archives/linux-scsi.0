From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 14/29] scsi: aacraid: Move function around to match
 existing code
Date: Thu, 21 Dec 2017 18:39:53 +0000
Message-ID: <1513881591.2931.21.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-15-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61240 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbdLUSjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 13:39:55 -0500
In-Reply-To: <20171221173420.8213-15-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <925029782671274E88EEAD95CACBFD16@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjM0IC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICsvKioNCj4gKyAqCWFhY19nZXRfc2Fmd19jaXNzX2x1bnMoKQlQcm9jZXNz
IHRvcG9sb2d5IGNoYW5nZQ0KPiArICoJQGRldjoJCWFhY19kZXYgc3RydWN0dXJlDQo+ICsgKglA
cmVzY2FuCQlJbmRpY2F0ZXMgcmVzY2FuDQo+ICsgKg0KPiArICoJRXhlY3V0ZSBhIENJU1MgUkVQ
T1JUIFBIWVMgTFVOUyBhbmQgcHJvY2VzcyB0aGUgcmVzdWx0cyBpbnRvDQo+ICsgKgl0aGUgY3Vy
cmVudCBoYmFfbWFwLg0KPiArICovDQoNClRoZSBhYm92ZSBmdW5jdGlvbiBoZWFkZXIgaXMgbm90
IGZvbGxvd2luZyB0aGUga2VybmVsLWRvYyBzeW50YXg6IGEgY29sb24gaXMNCm1pc3NpbmcuIEhh
dmUgeW91IHRyaWVkIHRvIGJ1aWxkIHlvdXIgZHJpdmVyIHdpdGggVz0xPyBUaGF0IHNob3VsZCBi
ZSBzdWZmaWNpZW50DQp3aXRoIGtlcm5lbCB2ZXJzaW9uIHY0LjE1LXJjMSBvciBsYXRlciB0byBy
ZXBvcnQga2VybmVsLWRvYyBoZWFkZXIgaXNzdWVzLg0KDQpCYXJ0Lg==
