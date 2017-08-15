From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCHv3 5/5] scsi_devinfo: fixup string compare
Date: Tue, 15 Aug 2017 23:03:16 +0000
Message-ID: <1502838194.2259.19.camel@wdc.com>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
         <1502461401-94630-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33079 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbdHOXED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2017 19:04:03 -0400
In-Reply-To: <1502461401-94630-6-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <379EF3A08BBEC446A7579B50AA6EC021@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

T24gRnJpLCAyMDE3LTA4LTExIGF0IDE2OjIzICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFdoZW4gY2hlY2tpbmcgdGhlIG1vZGVsIGFuZCB2ZW5kb3Igc3RyaW5nIHdlIG5lZWQgdG8g
dXNlIHRoZQ0KPiBtaW5pbXVtIHZhbHVlIG9mIGVpdGhlciBzdHJpbmcsIG90aGVyd2lzZSB3ZSds
bCBtaXNzIG91dCBvbg0KPiB3aWxkY2FyZCBtYXRjaGVzLg0KPiBBbmQgd2Ugc2hvdWxkIHRha2Ug
Y2FyZCB3aGVuIG1hdGNoaW5nIHdpdGggemVybyBzaXplIHN0cmluZ3M7DQoNCiJjYXJkIj8gRGlk
IHlvdSBwZXJoYXBzIG1lYW4gImNhcmUiPw0KDQo+IHJlc3VsdHMgbWlnaHQgYmUgdW5wcmVkaWN0
YWJsZS4NCj4gV2l0aCB0aGlzIHBhdGNoIHRoZSBydWxlcyBmb3IgbWF0Y2hpbmcgZGV2aW5mbyBz
dHJpbmdzIGFyZQ0KPiBhcyBmb2xsb3dzOg0KPiAtIFZlbmRvciBzdHJpbmdzIG11c3QgbWF0Y2gg
ZXhhY3RseQ0KPiAtIEVtcHR5IE1vZGVsIHN0cmluZ3Mgd2lsbCBvbmx5IG1hdGNoIGlmIHRoZSBk
ZXZpbmZvIG1vZGVsDQo+ICAgaXMgYWxzbyBlbXB0eQ0KPiAtIE1vZGVsIHN0cmluZ3Mgc2hvcnRl
ciB0aGFuIHRoZSBkZXZpbmZvIG1vZGVsIHN0cmluZyB3aWxsDQo+ICAgbm90IG1hdGNoDQoNClRo
ZSBhYm92ZSBzZW50ZW5jZSBjb250cmFkaWN0cyB0aGUgZmlyc3Qgc2VudGVuY2UuDQoNCj4gKwkJ
CS8qDQo+ICsJCQkgKiBAbW9kZWwgc3BlY2lmaWVzIHRoZSBmdWxsIHN0cmluZywgYW5kDQo+ICsJ
CQkgKiBtdXN0IGJlIGxhcmdlciBvciBlcXVhbCB0byBkZXZpbmZvLT5tb2RlbA0KPiArCQkJICov
DQoNCldoYXQgZG9lcyAibGFyZ2VyIHRoYW4gb3IgZXF1YWwgdG8iIG1lYW4gZm9yIHN0cmluZ3M/
IERpZCB5b3UgcGVyaGFwcyBtZWFuIHRoYXQNCmRldmluZm8tPm1vZGVsIG11c3QgYmUgYSBwcmVm
aXggb2YgQG1vZGVsPw0KDQo+ICAJCQlpZiAoIW1lbWNtcChkZXZpbmZvLT52ZW5kb3IsIHZlbmRv
ciwNCj4gLQkJCQkgICAgIHNpemVvZihkZXZpbmZvLT52ZW5kb3IpKSAmJg0KPiAtCQkJICAgICAh
bWVtY21wKGRldmluZm8tPm1vZGVsLCBtb2RlbCwNCj4gLQkJCQkgICAgICBzaXplb2YoZGV2aW5m
by0+bW9kZWwpKSkNCj4gKwkJCQkgICAgc2l6ZW9mKGRldmluZm8tPnZlbmRvcikpICYmDQo+ICsJ
CQkgICAgIW1lbWNtcChkZXZpbmZvLT5tb2RlbCwgbW9kZWwsDQo+ICsJCQkJICAgIHNpemVvZihk
ZXZpbmZvLT5tb2RlbCkpKQ0KPiAgCQkJCXJldHVybiBkZXZpbmZvOw0KDQpJcyB0aGlzIGEgd2hp
dGVzcGFjZS1vbmx5IGNoYW5nZT8gSWYgc28sIHBsZWFzZSBmb2xkIGl0IGluIHRoZSBwcmV2aW91
cyBwYXRjaC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
