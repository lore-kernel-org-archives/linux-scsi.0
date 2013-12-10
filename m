From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] isci: fix reset timeout handling
Date: Tue, 10 Dec 2013 13:18:15 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A696FF9@IRSMSX105.ger.corp.intel.com>
References: <20131209194650.27687.56358.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20131209194650.27687.56358.stgit@viggo.jf.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Ni, Xun" <xun.ni@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uZGF5LCBEZWNlbWJlciAwOSwgMjAxMyA4OjQ3IFBNIFdpbGxpYW1zLCBEYW4gSiA8ZGFu
Lmoud2lsbGlhbXNAaW50ZWwuY29tPiB3cm90ZToNCj4gUmVtb3ZlIGFuIGVycm9uZW91cyBCVUdf
T04oKSBpbiB0aGUgY2FzZSBvZiBhIGhhcmQgcmVzZXQgdGltZW91dC4gIElmIGENCj4gU0FUQSBk
ZXZpY2UgaXMgdW5hYmxlIHRvIHJlc3RvcmUgdGhlIGxpbmsgaW4gdGltZSB3ZSBleHBlY3QgdGhl
IHBvcnQgdG8NCj4gZ28gYmFjayB0byB0aGUgImF3YWl0aW5nIGxpbmstdXAiIHN0YXRlLiAgU2lu
Y2UgdGhlIHRpbWVvdXQgcGF0aA0KPiBub3RpZmllZCBsaWJzYXMgdGhhdCB0aGUgcG9ydCBpcyBk
b3duLCB3ZSB3YW50IHRvIG5vdGlmeSBsaWJzYXMgd2hlbiBpdA0KPiByZXR1cm5zIGFuZCBleHBl
Y3QgdGhhdCB0aGUgcG9ydCBtYXkgbm90IGJlIGluIHRoZSAicmVzZXR0aW5nIiBzdGF0ZS4NCj4g
DQo+IEFsc28sIG9uY2Ugd2UgaGF2ZSBub3RpZmllZCB0aGF0IHRoZSBwb3J0IGlzIGRvd24sIGlu
LXByb2dyZXNzIHJlc2V0cyBzaG91bGQNCj4gYWJvcnQgaW1tZWRpYXRlbHkuICBSZXR1cm4gLUVO
T0RFViBmcm9tIC0+bGxkZF9JX1RfbmV4dXNfcmVzZXQoKSB0byBpbmRpY2F0ZQ0KPiB0aGF0IGxp
YmF0YSBlcnJvciBoYW5kbGluZyBzaG91bGQgZW5kLg0KPiANCj4gQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPg0KPiBSZXBvcnRlZC1ieTogWHVuIE5pIDx4dW4ubmlAaW50ZWwuY29tPg0KPiBU
ZXN0ZWQtYnk6IFh1biBOaSA8eHVuLm5pQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoNCkFja2VkLWJ5OiBMdWthc3og
RG9yYXUgPGx1a2Fzei5kb3JhdUBpbnRlbC5jb20+DQoNCg==
