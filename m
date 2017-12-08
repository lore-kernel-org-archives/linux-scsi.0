From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: libiscsi: Allow sd_shutdown on bad transport
Date: Fri, 8 Dec 2017 23:12:31 +0000
Message-ID: <1512774750.26126.15.camel@wdc.com>
References: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33077 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbdLHXMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 18:12:35 -0500
In-Reply-To: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
Content-Language: en-US
Content-ID: <601505B0EE6872409A3C6D2B8DE1386A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lduncan@suse.com" <lduncan@suse.com>, "rafael.tinoco@canonical.com" <rafael.tinoco@canonical.com>, "cleech@redhat.com" <cleech@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "daniel.axtens@canonical.com" <daniel.axtens@canonical.com>, "dragan.stancevic@canonical.com" <dragan.stancevic@canonical.com>

T24gVGh1LCAyMDE3LTEyLTA3IGF0IDE5OjU5IC0wMjAwLCBSYWZhZWwgRGF2aWQgVGlub2NvIHdy
b3RlOg0KPiBUaGlzIGhhcHBlbnMgYmVjYXVzZSBpc2NzaV9laF9jbWRfdGltZWRfb3V0KCksIHRo
ZSB0cmFuc3BvcnQgbGF5ZXINCj4gdGltZW91dCBoZWxwZXIsIHdvdWxkIHRlbGwgdGhlIHF1ZXVl
IHRpbWVvdXQgZnVuY3Rpb24gKHNjc2lfdGltZXNfb3V0KQ0KPiB0byByZXNldCB0aGUgcmVxdWVz
dCB0aW1lciBvdmVyIGFuZCBvdmVyLCB1bnRpbCB0aGUgc2Vzc2lvbiBzdGF0ZSBpcw0KPiBiYWNr
IHRvIGxvZ2dlZCBpbiBzdGF0ZS4gVW5mb3J0dW5hdGVseSwgZHVyaW5nIHNlcnZlciBzaHV0ZG93
biwgdGhpcw0KPiBtaWdodCBuZXZlciBoYXBwZW4gYWdhaW4uDQoNCkhlbGxvIFJhZmFlbCwNCg0K
SGF2ZSB5b3UgY29uc2lkZXJlZCB0byBtYWtlIGlzY3NpX2VoX2NtZF90aW1lZF9vdXQoKSByZXR1
cm4gQkxLX0VIX0hBTkRMRUQNCmlmIHN5c3RlbV9zdGF0ZSAhPSBTWVNURU1fUlVOTklORz8gVGhh
dCBjb3VsZCByZXN1bHQgaW4gc2xvd2VyIHNodXRkb3duIHRoYW4NCndpdGggeW91ciBwYXRjaCBi
dXQgc3VjaCBhIGNoYW5nZSB3b3VsZCBwcm9iYWJseSBiZSByZWFsbHkgZWFzeSB0byByZXZpZXcu
DQoNClRoYW5rcywNCg0KQmFydC4=
