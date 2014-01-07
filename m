From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 7 Jan 2014 13:51:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D453DD4@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos> <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:42218 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751102AbaAGNxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 08:53:37 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 29879-07 for <linux-scsi@vger.kernel.org>;
 Tue,  7 Jan 2014 13:53:35 +0000 (GMT)
In-Reply-To: <52CC014C.5060604@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiBGcm9tOiB3YWx0DQouLi4NCj4gVGhhbmtzIFNhcmFoLiAgZG1lc2cwIGlzIGZyb20gdGhlIGRp
YWdub3N0aWMgcGF0Y2ggb25seS4gIGRtZXNnMSBoYXMgYWxsDQo+IHRocmVlIHBhdGNoZXMgYXBw
bGllZC4gIFNvbWUgb2YgdGhlIG1lc3NhZ2VzIGluIGRtZXNnMSBmZWxsIG9mZiB0aGUgZW5kIG9m
DQo+IHRoZSBrZXJuZWwgYnVmZmVyLCBzbyBJIG1heSBuZWVkIHRvIG1ha2UgdGhlIGJ1ZmZlciBs
YXJnZXIgbmV4dCB0aW1lIGJ1dA0KPiBJJ2xsIG5lZWQgYSByZW1pbmRlciBvZiBob3cgdG8gZG8g
aXQuDQo+IA0KPiBBcyB5b3Ugc3VzcGVjdGVkLCB0aGUgcGF0Y2hlcyBkaWRuJ3QgZml4IHRoZSBw
cm9ibGVtLCBzb3JyeS4NCg0KSSB0aGluayBTYXJhaCB3aWxsIHdhbnQgdGhlIHRyYWNlcyBvZiB0
aGUgdHJhbnNmZXIgYmVpbmcgc2V0dXAgKGllIGp1c3QNCmJlZm9yZSB0aGUgZXJyb3IpLiBTb21l
ICdub3JtYWwnIGNvbXBsZXRpbmcgdHJhbnNmZXJzIGFyZSBhbHNvIHVzZWZ1bC4NCg0KWW91IG1p
Z2h0IGFsc28gZmluZCB0aGUgZnVsbCB0cmFjZSBvdXRwdXQgaW4gb25lIG9mIHRoZSBmaWxlcyBp
biAvdmFyL2xvZy4NCg0KCURhdmlkDQoNCg==
