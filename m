From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Sat, 18 Mar 2017 15:28:29 +0000
Message-ID: <1489850894.2339.3.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
         <1489437175.2658.17.camel@sandisk.com>
         <1489442133.23810.24.camel@HansenPartnership.com>
         <1489705225.2574.22.camel@sandisk.com>
         <bdf76dc7-fa5f-ed9f-c16a-4d6165f8f952@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28842 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdCRP2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2017 11:28:36 -0400
In-Reply-To: <bdf76dc7-fa5f-ed9f-c16a-4d6165f8f952@suse.de>
Content-Language: en-US
Content-ID: <F461B191AE20ED4395113F55FD42020E@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

T24gU2F0LCAyMDE3LTAzLTE4IGF0IDEyOjE3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDAzLzE3LzIwMTcgMTI6MDAgQU0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBJ
IGhhZG4ndCBzZWVuIHRoaXMgY3Jhc2ggYmVmb3JlIGtlcm5lbCB2NC4xMS1yYzEgYnV0IHdpdGgg
a2VybmVsIHY0LjExLXJjMQ0KPiA+IGFuZCBsYXRlciBJIHNlZSBpdCBpZiBJIGxldCB0aGUgc3Jw
LXRlc3Qgc2NyaXB0cyBydW4gZm9yIGEgZmV3IG1pbnV0ZXMuIFRoZQ0KPiA+IHBhdGNoIEkgdXNl
ZCB0byBkaXNhYmxlIGFzeW5jIGFib3J0cyBvbiBteSB0ZXN0IHNldHVwIGlzIGFzIGZvbGxvd3M6
DQo+IA0KPiBUaGluZyBpcywgSSBkaWRuJ3QgY2hhbmdlIGFueXRoaW5nIGluIHRoZSBhc3luYyBh
Ym9ydCBjYXNlOyBhbGwgbXkNCj4gcGF0Y2hlcyBoYXZlbid0IGJlZW4gbWVyZ2VkIHlldC4NCj4g
U28gSSB3b3VsZCByYXRoZXIgdGhpbmsgdGhpcyBiZWluZyB0aGUgc2lkZSBlZmZlY3Qgb2Ygc29t
ZXRoaW5nIGVsc2UNCj4gDQo+IEFuZCBJIGp1c3Qgbm90aWNlZCB0aGF0IHlvdSBmb3VuZCB0aGUg
cmVhbCBpc3N1ZSB3aXRoIHlvdXIgYWx1YSBmaXhlcywNCj4gc28gSSBndWVzcyB0aGlzIGNhbiBi
ZSBpZ25vcmVkLCByaWdodD8NCg0KWWVzIC0gc29ycnkgZm9yIHRoZSBub2lzZS4gVGhpcyBjcmFz
aCBkaWQgbm90IG9jY3VyIHdpdGggdGhlIEFMVUEgZml4ZXMNCmFwcGxpZWQgYW5kIGFzeW5jIGFi
b3J0cyBlbmFibGVkLg0KDQpCYXJ0Lg==
