From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Tue, 16 Jan 2018 16:11:23 +0000
Message-ID: <1516119082.2844.5.camel@wdc.com>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
         <yq1k1xjjsly.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47919 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbeAPQLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2018 11:11:25 -0500
In-Reply-To: <yq1k1xjjsly.fsf@oracle.com>
Content-Language: en-US
Content-ID: <F83B7F6297B3984780FB1329DD76E452@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gTW9uLCAyMDE3LTEyLTE4IGF0IDIyOjM3IC0wNTAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IEhhbm5lcywNCj4gDQo+ID4gQXMgaXQgdHVybmVkIG91dCBkZXZpY2VfZ2V0KCkgZG9l
c24ndCB1c2Uga3JlZl9nZXRfdW5sZXNzX3plcm8oKSwNCj4gPiBzbyB3ZSB3aWxsIGJlIGFsd2F5
cyBnZXR0aW5nIGEgZGV2aWNlIHBvaW50ZXIuDQo+ID4gU28gd2UgbmVlZCB0byBjaGVjayBmb3Ig
dGhlIGRldmljZSBzdGF0ZSBpbiBfX3Njc2lfcmVtb3ZlX3RhcmdldCgpDQo+ID4gdG8gYXZvaWQg
dHJpcHBpbmcgb3ZlciBkZWxldGVkIG9iamVjdHMuDQo+IA0KPiBBcHBsaWVkIHRvIDQuMTUvc2Nz
aS1maXhlcy4gVGhhbmtzIQ0KDQpIZWxsbyBNYXJ0aW4sDQoNClNpbmNlIHRoYXQgcGF0Y2ggZml4
ZXMgYW4gaXNzdWUgdGhhdCB3YXMgaW50cm9kdWNlZCBpbiBrZXJuZWwgdjQuMTQgYnV0IGRpZA0K
bm90IGhhdmUgYSAiQ2M6IHN0YWJsZSIgdGFnLCBzaG91bGQgdGhpcyBwYXRjaCBiZSBzZW50IHRv
IEdyZWcgZm9yIGluY2x1c2lvbg0KaW4gdGhlIGtlcm5lbCB2NC4xNC54IHNlcmllcz8NCg0KVGhh
bmtzLA0KDQpCYXJ0Lg0KDQo=
