From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 21/43] qla2xxx: Remove calling cancel_work_sync()
Date: Wed, 20 Dec 2017 16:56:46 +0000
Message-ID: <1513789005.2603.30.camel@wdc.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
         <20171220065644.21511-22-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:21441 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755287AbdLTQ4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2017 11:56:50 -0500
In-Reply-To: <20171220065644.21511-22-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <CFE91F04E51D2143AA7CF1ACC5056183@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTEyLTE5IGF0IDIyOjU2IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBAQCAtMTIzNCw4ICsxMjM0LDYgQEAgdm9pZCBxbHRfc2NoZWR1bGVfc2Vzc19mb3JfZGVs
ZXRpb24oc3RydWN0IGZjX3BvcnQgKnNlc3MsDQo+ICAJcWxfZGJnKHFsX2RiZ190Z3QsIHNlc3Mt
PnZoYSwgMHhlMDAxLA0KPiAgCSAgICAiU2NoZWR1bGluZyBzZXNzICVwIGZvciBkZWxldGlvblxu
Iiwgc2Vzcyk7DQo+ICANCj4gLQkvKiB1c2UgY2FuY2VsIHRvIHB1c2ggd29yayBlbGVtZW50IHRo
cm91Z2ggYmVmb3JlIHJlLXF1ZXVlICovDQo+IC0JY2FuY2VsX3dvcmtfc3luYygmc2Vzcy0+ZGVs
X3dvcmspOw0KPiAgCUlOSVRfV09SSygmc2Vzcy0+ZGVsX3dvcmssIHFsYTI0eHhfZGVsZXRlX3Nl
c3NfZm4pOw0KPiAgCXF1ZXVlX3dvcmsoc2Vzcy0+dmhhLT5ody0+d3EsICZzZXNzLT5kZWxfd29y
ayk7DQoNCldoeSBoYWQgdGhpcyBjYW5jZWxfd29ya19zeW5jKCkgY2FsbCBiZWVuIGludHJvZHVj
ZWQgaW4NCnFsdF9zY2hlZHVsZV9zZXNzX2Zvcl9kZWxldGlvbigpIGFuZCB3aHkgZG8geW91IHRo
aW5rIGl0IGlzIHNhZmUgdG8gcmVtb3ZlDQp0aGlzIGNhbGw/IEJvdGggcXVlc3Rpb25zIHNob3Vs
ZCBoYXZlIGJlZW4gYW5zd2VyZWQgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9uLg0KDQpUaGFua3Ms
DQoNCkJhcnQu
