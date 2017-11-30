From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 05/22] qla2xxx: Fix re-login for Nport Handle in use
Date: Thu, 30 Nov 2017 17:37:46 +0000
Message-ID: <1BBEFC2A-D0E2-42B0-9FD6-C8EBCF34541A@cavium.com>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
 <20171130034047.15070-6-himanshu.madhani@cavium.com>
 <b1e8b1b5-b6c0-9a2b-d496-34063d730712@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0046.outbound.protection.outlook.com ([104.47.38.46]:4439
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752640AbdK3Rhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 12:37:48 -0500
In-Reply-To: <b1e8b1b5-b6c0-9a2b-d496-34063d730712@suse.de>
Content-Language: en-US
Content-ID: <A31C401F26592A47B77A2D6B7EF261D1@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgSGFubmVzLCANCg0KPiBPbiBOb3YgMzAsIDIwMTcsIGF0IDc6NTEgQU0sIEhhbm5lcyBSZWlu
ZWNrZSA8aGFyZUBzdXNlLmRlPiB3cm90ZToNCj4gDQo+IERvZXMgdGhpcyByZWFsbHkgYmVsb25n
IHRvIHRoZSBhYm92ZSBwYXRjaD8NCj4gSXQgbG9va3MgdG8gbWUgYXMgaWYgaXQgZml4ZXMgYSBj
b21wbGV0ZWx5IGRpZmZlcmVudCBpc3N1ZS4uLg0KDQpUaGlzIGZsYWcgaW5kaWNhdGVzIGZpcm13
YXJlIHRvIHB1cmdlIGFsbCBJT+KAmXMgb2YgYSBzZXNzaW9uIGluc3RlYWQgb2YgDQphc3N1bWlu
ZyBGVyB3aWxsIHB1cmdlIHRoZW0uDQoNCmlmIHlvdSBwcmVmZXIgdG8gaGF2ZSB0aGlzIGFzIGEg
c2VwYXJhdGUgcGF0Y2guIEkgY2FuIHBvc3QgdjMgd2l0aCBuZXcgcGF0Y2guDQoNClRoYW5rcywN
Ci0gSGltYW5zaHUNCg0K
