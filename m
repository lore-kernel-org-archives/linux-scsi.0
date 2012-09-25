From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH 2/3] libfc: fix lun reset failure bugs in fc_fcp_resp
 handling of FCP_RSP_INFO
Date: Tue, 25 Sep 2012 16:20:43 +0000
Message-ID: <138EA028228D124A900F5E6746F3C2162F4F78E5@ORSMSX102.amr.corp.intel.com>
References: <20120924185240.521.22975.stgit@fritz>
 <20120924185250.521.92611.stgit@fritz> <50614CED.1010707@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4501 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab2IYQVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 12:21:08 -0400
In-Reply-To: <50614CED.1010707@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Love, Robert W" <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Brattain, Ross B" <ross.b.brattain@intel.com>, "Zhang, Frank_1" <frank_1.zhang@intel.com>

PiANCj4gT24gMDkvMjQvMTIgMjA6NTIsIFJvYmVydCBMb3ZlIHdyb3RlOg0KPiA+IEluIExVTiBS
RVNFVCB0ZXN0aW5nIGludm9sdmluZyBOZXRBcHAgdGFyZ2V0cywgaXQgaXMgb2JzZXJ2ZWQgdGhh
dCBMVU4NCj4gPiBSRVNFVCBpcyBmYWlsaW5nLiBUaGUgZmNfZmNwX3Jlc3AoKSBpcyBub3QgY29t
cGxldGluZyB0aGUgY29tcGxldGlvbmcNCj4gDQo+IEl0IGxvb2tzIGxpa2UgdGhlcmUgaXMgYSB0
eXBvIGluIHRoZSBwYXRjaCBkZXNjcmlwdGlvbiAoaW4gdGhlIGxhc3Qgd29yZA0KPiBvZiB0aGUg
c2Vjb25kIGxpbmUpID8NCj4gDQo+IEJhcnQuDQoNClllYWgsIGV4dHJhICdnJyBzaG91bGQgYmUg
cmVtb3ZlZC4uLm1lYW50IHRvIHNheSB0aGUgImNvbXBsZXRpb24gdGFzayIuLi4NCkhtbSwgbm90
IHN1cmUgaG93IG15IHZpbSBzcGVsbGNoZWNrZXIgbWlzc2VkIGl0LiANCg0KSmFtZXMsIHdvdWxk
IG1pbmQgZml4aW5nIHRoaXMgd2hlbiBpdCBnZXRzIGFwcGxpZWQ/DQoNClRoYW5rcywNCnlpDQo=
