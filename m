From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Tue, 14 Mar 2017 02:35:58 +0000
Message-ID: <1489458944.2987.1.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
         <1489437175.2658.17.camel@sandisk.com>
         <1489442133.23810.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54193 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdCNCgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 22:36:08 -0400
In-Reply-To: <1489442133.23810.24.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <12D4DB28609AF74CBD2F57F192729234@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

T24gTW9uLCAyMDE3LTAzLTEzIGF0IDE0OjU1IC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IFRoaXMgaXMgdHJ1ZSwgYnV0IEkgZG9uJ3Qgc2VlIGhvdyBpdCBjYW4gY2F1c2UgdGhlIGhv
c3QgdG8gYmUgZnJlZWQNCj4gYmVmb3JlIHRoZSBzZGV2LiAgVGhlIG1lbW9yeSBmb3Igc3RydWN0
IFNjc2lfSG9zdCBpcyBmcmVlZCBpbiB0aGUNCj4gc2hvc3RfZ2VuZGV2IHJlbGVhc2Ugcm91dGlu
ZSwgd2hpY2ggc2hvdWxkIGJlIHBpbm5lZCBieSB0aGUgcGFyZW50DQo+IHRyYXZlcnNhbCBmcm9t
IHNkZXYuICBTbyBpdCBzaG91bGQgbm90IGJlIHBvc3NpYmxlIGZvcg0KPiAgc2NzaV9ob3N0X2Rl
dl9yZWxlYXNlKCkgdG8gYmUgY2FsbGVkIGJlZm9yZQ0KPiAgc2NzaV9kZXZpY2VfZGV2X3JlbGVh
c2VfdXNlcmNvbnRleHQoKSBiZWNhc2UgdGhlIGxhdHRlciBoYXMgdGhlIGZpbmFsDQo+IHB1dCBv
ZiB0aGUgcGFyZW50IGRldmljZS4NCg0KSGVsbG8gSmFtZXMsDQoNCkkgd2lsbCBydW4gYSBiaXNl
Y3QgdG8gc2VlIHdoZXRoZXIgdGhhdCBwcm92aWRlcyBtb3JlIGluZm9ybWF0aW9uIGFib3V0DQp3
aGF0IGNhdXNlZCB0aGUgY2hhbmdlIGluIHRoZSByZWZlcmVuY2UgY291bnRpbmcgYmVoYXZpb3Iu
DQoNCklzcmFlbCwgc2luY2UgeW91IGRpZCBub3QgaGl0IHRoZSByZWZlcmVuY2UgY291bnRpbmcg
aXNzdWUgaW4geW91ciB0ZXN0cywNCmNhbiB5b3UgcmVwZWF0IHlvdXIgdGVzdCB3aXRoIHBhdGNo
ZXMgMywgNCBhbmQgNSBhcHBsaWVkPw0KDQpUaGFua3MsDQoNCkJhcnQu
