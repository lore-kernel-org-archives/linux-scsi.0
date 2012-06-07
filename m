From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 4/6] bnx2fc: Improve error recovery by handling parity
 errors
Date: Thu, 7 Jun 2012 03:03:29 +0000
Message-ID: <1339038209.26595.2.camel@dabdike.int.hansenpartnership.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
	 <1338851747-7240-5-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:43173 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2FGDDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jun 2012 23:03:35 -0400
In-Reply-To: <1338851747-7240-5-git-send-email-bprakash@broadcom.com>
Content-Language: en-US
Content-ID: <66619340C6EB9B488E73ACE3E47B43DC@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

T24gTW9uLCAyMDEyLTA2LTA0IGF0IDE2OjE1IC0wNzAwLCBCaGFudSBQcmFrYXNoIEdvbGxhcHVk
aSB3cm90ZToNCj4gQEAgLTMyMSw2ICszMzIsOSBAQCBzdGF0aWMgdm9pZCBibngyZmNfdXBsb2Fk
X3Nlc3Npb24oc3RydWN0IGZjb2VfcG9ydCAqcG9ydCwNCj4gIA0KPiAgCQlkZWxfdGltZXJfc3lu
YygmdGd0LT51cGxkX3RpbWVyKTsNCj4gIA0KPiArCX0gZWxzZSBpZiAodGVzdF9iaXQoQk5YMkZD
X0ZMQUdfRElTQUJMRV9GQUlMRUQsICZ0Z3QtPmZsYWdzKSkNCj4gKwkJcHJpbnRrKEtFUk5fRVJS
IFBGWCAiRVJST1IhISBESVNBQkxFIHJlcSBmYWlsZWQsIGRlc3Ryb3kiDQo+ICsJCQkJIiBub3Qg
c2VudCB0byBGV1xuIik7DQo+ICAJfSBlbHNlDQo+ICAJCXByaW50ayhLRVJOX0VSUiBQRlggIkVS
Uk9SISEgRElTQUJMRSByZXEgdGltZWQgb3V0LCBkZXN0cm95Ig0KPiAgCQkJCSIgbm90IHNlbnQg
dG8gRldcbiIpOw0KDQpZb3UgZGlkbid0IGFjdHVhbGx5IGNvbXBpbGUgdGhpcyBkaWQgeW91PyAg
VGhhdCBlbHNlIGlmIGhhcyB0byBoYXZlIGFuDQpvcGVuaW5nIGJyYWNlIHRvIG1hdGNoIHRoZSBj
bG9zaW5nIG9uZSBvbiB0aGUgbmV4dCBlbHNlIC4uLg0KDQpKYW1lcw0KDQo=
