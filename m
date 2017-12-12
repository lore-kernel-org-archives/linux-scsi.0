From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/4] block: check for GENHD_FL_UP in del_gendisk()
Date: Tue, 12 Dec 2017 16:57:02 +0000
Message-ID: <1513097821.2999.12.camel@sandisk.com>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
         <1513069072-32514-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:51607 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdLLQ5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 11:57:04 -0500
In-Reply-To: <1513069072-32514-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <1168FCA3C801CD4CA94661BB53827D74@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDA5OjU3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IEZyb206IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4NCj4gDQo+IFdoZW4gYSBk
ZXZpY2UgaXMgcHJvYmVkIGFzeW5jaHJvbm91c2x5IGRlbF9nZW5kaXNrKCkgbWlnaHQgYmUgY2Fs
bGVkDQo+IGJlZm9yZSB0aGUgYXN5bmMgcHJvYmluZyB3YXMgcnVuLCBjYXVzaW5nIGRlbF9nZW5k
aXNrKCkgdG8gY3Jhc2gNCj4gZHVlIHRvIHVuaW5pdGlhbGl6ZWQgc3lzZnMgb2JqZWN0cy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4NCj4gLS0t
DQo+ICBibG9jay9nZW5oZC5jIHwgMyArKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2svZ2VuaGQuYw0K
PiBpbmRleCBjMjIyM2YxLi5jYzQwZDk1IDEwMDY0NA0KPiAtLS0gYS9ibG9jay9nZW5oZC5jDQo+
ICsrKyBiL2Jsb2NrL2dlbmhkLmMNCj4gQEAgLTY5Nyw2ICs2OTcsOSBAQCB2b2lkIGRlbF9nZW5k
aXNrKHN0cnVjdCBnZW5kaXNrICpkaXNrKQ0KPiAgCXN0cnVjdCBkaXNrX3BhcnRfaXRlciBwaXRl
cjsNCj4gIAlzdHJ1Y3QgaGRfc3RydWN0ICpwYXJ0Ow0KPiAgDQo+ICsJaWYgKCEoZGlzay0+Zmxh
Z3MgJiBHRU5IRF9GTF9VUCkpDQo+ICsJCXJldHVybjsNCj4gKw0KPiAgCWJsa19pbnRlZ3JpdHlf
ZGVsKGRpc2spOw0KPiAgCWRpc2tfZGVsX2V2ZW50cyhkaXNrKTsNCg0KSGVsbG8gSGFubmVzLA0K
DQpUaGFuayB5b3UgZm9yIGhhdmluZyBwdWJsaXNoZWQgeW91ciBhcHByb2FjaCBmb3IgaW5jcmVh
c2luZyBkaXNrIHByb2JpbmcNCmNvbmN1cnJlbmN5LiBZb3VyIGFwcHJvYWNoIGxvb2tzIGludGVy
ZXN0aW5nIHRvIG1lLiBIb3dldmVyLCBJIGRvbid0IHRoaW5rDQp0aGF0IHBhdGNoZXMgMS80Li4z
LzQgYXJlIHN1ZmZpY2llbnQgdG8gYXZvaWQgcmFjZXMgYmV0d2VlbiBlLmcuDQpkZXZpY2VfYWRk
X2Rpc2soKSBhbmQgZGVsX2dlbmRpc2soKS4gQXMgZmFyIGFzIEkga25vdyBubyBsb2NrcyBhcmUg
aGVsZA0KYXJvdW5kIHRoZSBkZXZpY2VfYWRkX2Rpc2soKSBhbmQgZGVsX2dlbmRpc2soKSBjYWxs
cy4gRG9lcyB0aGF0IG1lYW4gdGhhdA0KZGVsX2dlbmRpc2soKSBjYW4gY2FsbCBlLmcuIGJsa19p
bnRlZ3JpdHlfZGVsKCkgYmVmb3JlIGRldmljZV9hZGRfZGlzaygpIGhhcw0KY2FsbGVkIGJsa19p
bnRlZ3JpdHlfYWRkKCk/DQoNCkJhcnQu
