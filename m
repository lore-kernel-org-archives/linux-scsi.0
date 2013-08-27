From: "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH v3 2/2] Hard disk S3 resume time optimization
Date: Tue, 27 Aug 2013 14:50:31 +0000
Message-ID: <11E08D716F0541429B7042699DD5C1A1706A8371@FMSMSX103.amr.corp.intel.com>
References: <20130823214340.GC11321@todd.e.brandt@intel.com>
 <1377332485.1790.3.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3H0Ouq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 10:50:46 -0400
In-Reply-To: <1377332485.1790.3.camel@linux-fkkt.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

QWxsIHRoZSBzYW1lIGNoZWNrcyBhcmUgcHJlc2VydmVkLCBpbmNsdWRpbmcgdGhlIG1hbmFnZV9z
dGFydF9zdG9wIGNoZWNrOg0KDQorCWlmICghc2RrcC0+ZGV2aWNlLT5tYW5hZ2Vfc3RhcnRfc3Rv
cCkNCisJCWdvdG8gZXJyb3I7DQoNClRoYXQgZnVuY3Rpb24gaXMganVzdCBhIHNpbXBsaWZpZWQg
dmVyc2lvbiBvZiBzZF9zdGFydF9zdG9wX2RldmljZSBidXQgd2l0aCBvbmx5IHRoZSBzdGFydCBm
dW5jdGlvbmFsaXR5IHVzZWQuDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBP
bGl2ZXIgTmV1a3VtIFttYWlsdG86b25ldWt1bUBzdXNlLmRlXSANClNlbnQ6IFNhdHVyZGF5LCBB
dWd1c3QgMjQsIDIwMTMgMToyMSBBTQ0KVG86IEJyYW5kdCwgVG9kZCBFDQpDYzogbGludXgtaWRl
QHZnZXIua2VybmVsLm9yZzsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IHRqQGtlcm5lbC5v
cmc7IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOyBzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1
DQpTdWJqZWN0OiBSZTogW1BBVENIIHYzIDIvMl0gSGFyZCBkaXNrIFMzIHJlc3VtZSB0aW1lIG9w
dGltaXphdGlvbg0KDQpPbiBGcmksIDIwMTMtMDgtMjMgYXQgMTQ6NDMgLTA3MDAsIEJyYW5kdCwg
VG9kZCBFIHdyb3RlOg0KPiBUaGlzIGlzIHYzIG9mIHRoZSBub24tYmxvY2tpbmcgUzMgcmVzdW1l
IHBhdGNoLiBJdCdzIGJlZW4gYnJva2VuIGludG8NCj4gdHdvIHBpZWNlcywgdGhpcyBwYXJ0IGlz
IGZvciB0aGUgc2NzaSBzdWJzeXN0ZW0uIEkndmUgYWRkcmVzc2VkIEFsYW4gDQo+IFN0ZXJuJ3Mg
Y29tbWVudHMgaW4gcGFydGljdWxhciBieSByZWZvcm1hdHRpbmcgdGhlIGNhbGwgdG8gY29uZm9y
bQ0KPiB0byB0aGUgcHJvcGVyIHN0eWxlIGd1aWRlbGluZXMuDQoNCkhpLA0KDQp5b3UgYXJlIGNo
YW5naW5nIHRoZSBnZW5lcmljIHJlc3VtZSBmb3IgYWxsIHNkIGRpc2tzLg0KSW4gcGFydGljdWxh
ciwgeW91IGFyZSBkcm9wcGluZyB0aGUgY2hlY2sgb2YNCnNka3AtPmRldmljZS0+bWFuYWdlX3N0
YXJ0X3N0b3ANCldoYXQgaGFwcGVucyBpZiB5b3UgdXNlIHRoaXMgcGF0Y2ggb24gYSByZWFsIFND
U0kgZGlzaz8NCg0KCVJlZ2FyZHMNCgkJT2xpdmVyDQoNCg0K
