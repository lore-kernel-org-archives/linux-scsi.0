From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and device
 removal
Date: Fri, 17 Nov 2017 17:28:18 +0000
Message-ID: <1510939697.2846.29.camel@wdc.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
         <1479016028.17624.16.camel@linux.vnet.ibm.com>
         <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
         <CAD+HZHUVsaDYO7yL2Ct868kdK=dE3PuRmy-Jfp2d2zmEBJPwFg@mail.gmail.com>
         <1510680828.2280.16.camel@sandisk.com>
         <CAD+HZHWAUPRxHyG0VRcfTmBs2KbUX30wsa7=HGGApQ94sEj26g@mail.gmail.com>
         <1510938082.2846.23.camel@wdc.com>
         <CAD+HZHXUd2TwfX9WSQad1edmfXfmRNYgQ6N=_3Ny3JyH=q8QXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44594 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbdKQR2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 12:28:21 -0500
In-Reply-To: <CAD+HZHXUd2TwfX9WSQad1edmfXfmRNYgQ6N=_3Ny3JyH=q8QXQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <BFC2C9B1B352A54E970B00AFCF74FD04@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>

T24gRnJpLCAyMDE3LTExLTE3IGF0IDE4OjEwICswMTAwLCBKYWNrIFdhbmcgd3JvdGU6DQo+IEl0
J3MgcHJvZHVjdGlvbiBzZXJ2ZXIsIEkgd2FzIHRvbyBsYXRlIHRvIGdhdGhlciBtb3JlIGluZm9y
bWF0aW9uLg0KPiBrZXJuZWwgaXMgNC40LjM2LzQuNC41MA0KPiBSZXF1ZXN0IG1vZGUgZm9yIGJv
dGggbXVsdGlwYXRoIGFuZCBzY3NpLCBubyBtdWx0aXF1ZXVlIGludm9sdmVtZW50Lg0KDQpIZWxs
byBKYWNrLA0KDQpJIGhhdmVuJ3Qgc2VlbiBhbnkgbG9ja3VwcyB3aXRoIHRoZSBtdWx0aXBhdGgg
KyBTUlAgYW5kIHRoZSBsZWdhY3kgYmxvY2sNCmFuZCBTQ1NJIGxheWVycyBpbiBhIGxvbmcgdGlt
ZS4gU28gZWl0aGVyIHNvbWV0aGluZyB3ZW50IHdyb25nIHdpdGgNCmJhY2twb3J0aW5nIHVwc3Ry
ZWFtIGZpeGVzLCBhbiB1cHN0cmVhbSBmaXggaGFzIG5vdCBiZWVuIGJhY2twb3J0ZWQgdG8ga2Vy
bmVsDQo0LjQuMzYgb3IgdGhlIGxvY2t1cCBpcyBjYXVzZWQgYnkgdGhlIFNDU0kgTExEIGluIHlv
dXIgc2V0dXAsIGUuZy4gYSBtaXNzaW5nDQotPnNjc2lfZG9uZSgpIGNhbGwuIFNpbmNlIHRoZSBz
cnAtdGVzdCBzb2Z0d2FyZSBwYXNzZXMgb24geW91ciBzZXR1cCB0aGUNCmxhdHRlciBtYXkgYmUg
dGhlIG1vc3QgbGlrZWx5Lg0KDQpCYXJ0Lg==
