From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 05/11] qla2xxx: Fix wrong argument in sp done callback.
Date: Mon, 9 Jan 2017 18:05:33 +0000
Message-ID: <A0A0729A-C689-49AC-97C9-C73084B3A6CC@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-6-git-send-email-himanshu.madhani@cavium.com>
 <20170109131710.GC4438@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0079.outbound.protection.outlook.com ([104.47.41.79]:48256
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1422940AbdAISFh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Jan 2017 13:05:37 -0500
In-Reply-To: <20170109131710.GC4438@infradead.org>
Content-Language: en-US
Content-ID: <7464A6217B772E4B8DF221C5A37F4423@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQpPbiAxLzkvMTcsIDU6MTcgQU0sICJDaHJpc3RvcGggSGVsbHdpZyIgPGhjaEBpbmZyYWRlYWQu
b3JnPiB3cm90ZToNCg0KPk9uIEZyaSwgRGVjIDIzLCAyMDE2IGF0IDA4OjIzOjMzUE0gLTA4MDAs
IEhpbWFuc2h1IE1hZGhhbmkgd3JvdGU6DQo+PiBGcm9tOiBRdWlubiBUcmFuIDxxdWlubi50cmFu
QGNhdml1bS5jb20+DQo+PiANCj4+IENhbGxiYWNrIGZvciBzcC0+ZG9uZSBleHBlY3RzIHNjc2lf
cWxhX2hvc3QgaXMgcGFzc2VkIGluIGFzIGFyZ3VtZW50LA0KPj4gSW5zdGVhZCBxbGFfaHdfZGF0
YSBpcyBwYXNzZWQgaW4uDQo+DQo+UGxlYXNlIGFsc28gZml4IHRoZSBwcm90b3R5cGUgb2YgdGhl
IGRvbmUgYW5kIGZyZWUgY2FsbGJhY2tzIHRvIHVzZSB0aGUNCj5hY3R1YWwgdHlwZSBpbnN0ZWFk
IG9mIHR3byB2b2lkIHBvaW50ZXJzLCBzbyB0aGF0IHRoZSBjb21waWxlciBjYW4gY2F0Y2gNCj5i
dWdzIGxpa2UgdGhpcyBpbiB0aGUgZnV0dXJlLg0KDQpJIGhhdmUgcGF0Y2ggZm9yIHRoZSBmaXhp
bmcgb2YgcHJvdG90eXBlIG9mIGRvbmUgYW5kIGZyZWUgY2FsbGJhY2tzIHdoaWNoIEkgd2FzDQpw
bGFubmluZyB0byBzZW5kIG91dCBhZnRlciB0aGlzIHNlcmllcy4gSeKAmWxsIGluY2x1ZGUgdGhh
dCBpbiBWMiBvZiB0aGlzIHNlcmllcy4NCg0KPg0K
