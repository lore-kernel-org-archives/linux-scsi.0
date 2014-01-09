From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Thu, 9 Jan 2014 10:05:11 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D455F92@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos> <52CDF9CD.8010402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:46698 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751530AbaAIKG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 05:06:57 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 08692-08 for <linux-scsi@vger.kernel.org>;
 Thu,  9 Jan 2014 10:06:55 +0000 (GMT)
In-Reply-To: <52CDF9CD.8010402@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiBGcm9tOiB3YWx0DQouLi4NCj4gSSdtIHN0aWxsIHdvbmRlcmluZyBpZiBJJ20gc3VmZmVyaW5n
IGZyb20gaGFyZHdhcmUgcXVpcmtzLiAgRnJvbSB0aGUNCj4gZmlyc3QgZGF5IEkgaW5zdGFsbGVk
IG15IHVzYjMgYWRhcHRlciBjYXJkIGFuZCB0aGUgdXNiMyBkaXNrIGRvY2tpbmcNCj4gc3RhdGlv
biBJJ3ZlIG5vdGljZWQgc29tZSBxdWlya3kgYmVoYXZpb3IuDQoNCkFoIC0gdGhpcyBpc24ndCBh
biAnb24gY2hpcCcgdXNiMyBhZGFwdGVyLg0KU29tZSBraW5kIG9mIFBDSWUgY2FyZCA/DQoNCj4g
ZS5nLiBJIGJvb3QgdGhlIG1hY2hpbmUgd2l0aCB0aGUgZG9ja2luZyBzdGF0aW9uIHBvd2VyZWQt
b2ZmLCBhbmQgdGhlbg0KPiBsYXRlciBJIHBvd2VyIGl0IG9uLCB0aGUgdXNiMyBkaXNrIGlzIG5v
dCBkZXRlY3RlZCBhdCBhbGwgLS0gdW50aWwgSQ0KPiByZWJvb3QgdGhlIG1hY2hpbmUgd2l0aCB0
aGUgZG9ja2luZyBzdGF0aW9uIHN0aWxsIHBvd2VyZWQgb24uDQoNClRoYXQgd2lsbCBiZSBzb21l
dGhpbmcgY29tcGxldGVseSBkaWZmZXJlbnQgdG8gZmFpbHVyZXMgd2hlbiBydW5uaW5nLg0KDQoJ
RGF2aWQNCg0K
