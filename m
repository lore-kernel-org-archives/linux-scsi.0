From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 25/29] scsi: aacraid: Reschedule host scan in case of
 failure
Date: Thu, 21 Dec 2017 18:44:49 +0000
Message-ID: <1513881887.2931.24.camel@wdc.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-26-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11355 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdLUSov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 13:44:51 -0500
In-Reply-To: <20171221173420.8213-26-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Content-ID: <94ACB0FA12E6ED4BB522A17CCDD5DA04@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "aacraid@microsemi.com" <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "tom.white@microsemi.com" <tom.white@microsemi.com>, "Scott.Benesh@microsemi.com" <Scott.Benesh@microsemi.com>

T24gVGh1LCAyMDE3LTEyLTIxIGF0IDA5OjM0IC0wODAwLCBSYWdoYXZhIEFkaXR5YSBSZW51a3Vu
dGEgd3JvdGU6DQo+ICsJc3RydWN0IGRlbGF5ZWRfd29yawlzYWZ3X3Jlc2Nhbl93b3JrZXI7DQoN
ClBsZWFzZSBtYWtlIHRoZSBuYW1lIG9mIHRoaXMgbWVtYmVyIHZhcmlhYmxlIGNvbnNpc3RlbnQg
d2l0aCBvdGhlciBrZXJuZWwgY29kZS4gVGhhdA0KbWVhbnMgZWl0aGVyIHVzaW5nIGUuZy4gdGhl
IG5hbWUgInNhZndfcmVzY2FuX3dvcmsiIG9yICJzYWZ3X3Jlc2NhbiIuDQoNClRoYW5rcywNCg0K
QmFydC4=
