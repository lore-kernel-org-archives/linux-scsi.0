From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Fri, 10 Jan 2014 14:58:03 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D457C16@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D0065B.4060905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:43137 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751388AbaAJO7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jan 2014 09:59:54 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 25564-10 for <linux-scsi@vger.kernel.org>;
 Fri, 10 Jan 2014 14:59:53 +0000 (GMT)
In-Reply-To: <52D0065B.4060905@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

RnJvbTogd2FsdA0KPiA+IEluIHRoZSBtZWFudGltZSwgdHJ5IHRoaXMgcGF0Y2gsIHdoaWNoIGlz
IHNvbWV0aGluZyBvZiBhIGxvbmcgc2hvdC4NCj4gDQo+IE5vIGRpZmZlcmVuY2UuICBCdXQgSSBu
b3RpY2UgdGhlIGNvZGUgZW5hYmxlcyB0aGUgVFJCIHF1aXJrIG9ubHkgaWYgdGhlDQo+IHhoY2lf
dmVyc2lvbiBpcyBzcGVjaWZpY2FsbHkgMHg5NS4gIE15IGRlYnVnIG1lc3NhZ2VzIGNsYWltIHRo
YXQgInhIQ0kNCj4gZG9lc24ndCBuZWVkIGxpbmsgVFJCIFFVSVJLIiBzbyBJJ20gd29uZGVyaW5n
IGlmIGFkZGluZyBteSBhc21lZGlhIGRldmljZQ0KPiB0byB0aGUgcXVpcmtzIGxpc3QgcmVhbGx5
IGRvZXNuJ3QgY2hhbmdlIGFueXRoaW5nIHVubGVzcyBpdCdzIHhoY2kgMC45NS4NCg0KSSB0aGlu
ayB0aGUgaW50ZW50aW9uIHdhcyB0aGF0IHRoZSBxdWlyayB3b3VsZCBiZSBhcHBsaWVkIGZvciB5
b3VyDQpoYXJkd2FyZSBldmVuIHRob3VnaCBpdCBjbGFpbXMgdG8gYmUgdmVyc2lvbiAwLjk2Lg0K
VGhhdCB3YXMgZ3VzdCBhIGhvcGVmdWwgZ3Vlc3MgdGhhdCB0aGUgc2FtZSBjaGFuZ2Ugd291bGQg
aGVscC4NCg0KPiBEb2VzIGxzcGNpIHByb3ZpZGUgdGhhdCBpbmZvcm1hdGlvbj8gIEknbSBub3Qg
c2VlaW5nIGFueXRoaW5nIG9idmlvdXMuDQpJJ3ZlIG9ubHkgc2VlbiBpdCBpbiB0aGUgZGlhZ25v
c3RpYyBwcmludHMgKHRoYXQgYXJlbid0IG5vcm1hbGx5IG91dHB1dCkuDQoNCglEYXZpZA0KDQo=
