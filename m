From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: fix handling of fc frame in fc_exch_recv_bls()
Date: Wed, 20 Oct 2010 22:41:45 +0800
Message-ID: <AANLkTin51mat0NAZrrT45qVc66SPxYOjUPEQ=9YfYxFx@mail.gmail.com>
References: <AANLkTikQYBNsV2vbAfG+xe+ruJq+vfFTvJPOMUXAApXT@mail.gmail.com>
	<7C88852EF6F99F4EB538472FCFEBE2220146CC7FC7@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46505 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0JTOlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2010 10:41:47 -0400
Received: by wwf26 with SMTP id 26so1277404wwf.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2010 07:41:46 -0700 (PDT)
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE2220146CC7FC7@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Z29vZCBjb21tZW50IGFuZCB0aGFua3MgLy9IaWxsZgoKT24gVHVlLCBPY3QgMTksIDIwMTAgYXQg
MTE6MDAgUE0sIFpvdSwgWWkgPHlpLnpvdUBpbnRlbC5jb20+IHdyb3RlOgo+Pgo+PiBUaGVyZSBz
ZWVtcyB0aGF0IGZwIHNob3VsZCBnZXQgZnJlZWQgaWYgZXhjaCBpcyB1bmF2YWlsYWJsZS4KPj4K
Pj4gU2lnbmVkLW9mZi1ieTogSGlsbGYgRGFudG9uIDxkaGlsbGZAZ21haWwuY29tPgo+PiAtLS0K
Pj4KPj4gLS0tIGEvZHJpdmVycy9zY3NpL2xpYmZjL2ZjX2V4Y2guYyDCoCDCoDIwMTAtMDktMTMg
MDc6MDc6MzguMDAwMDAwMDAwICswODAwCj4+ICsrKyBiL2RyaXZlcnMvc2NzaS9saWJmYy9mY19l
eGNoLmMgwqAgwqAyMDEwLTEwLTE5IDIxOjM1OjA4LjAwMDAwMDAwMCArMDgwMAo+PiBAQCAtMTU2
NCw4ICsxNTY0LDExIEBAIHN0YXRpYyB2b2lkIGZjX2V4Y2hfcmVjdl9ibHMoc3RydWN0IGZjX2UK
Pj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZmNfZnJhbWVf
ZnJlZShmcCk7Cj4+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOwo+PiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBjYXNlIEZDX1JDVExfQkFfQUJUUzoKPj4gLSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBmY19leGNoX3JlY3ZfYWJ0cyhlcCwgZnApOwo+PiAtIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOwo+PiArIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGlmIChlcCkgewo+PiArIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGZjX2V4Y2hfcmVjdl9hYnRzKGVwLCBmcCk7Cj4+ICsgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7Cj4+ICsgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgfQo+PiArIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIC8qIGZhbGwg
dGhydSAqLwo+PiDCoCDCoCDCoCDCoCDCoCDCoCDCoCBkZWZhdWx0OiDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoC8qIGlnbm9yZSBqdW5rICovCj4+IMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGZjX2ZyYW1lX2ZyZWUoZnApOwo+PiDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCBicmVhazsKPgo+IE5vLCBmY19leGNoX3JlY3ZfYWJ0cygpIGFscmVhZHkg
Y2hlY2tzIGVwIGF0IGl0cyB2ZXJ5IGJlZ2lubmluZyBhbmQgZ2V0cwo+IGZyZWVkIHRoZXJlLgo+
Cj4geWkKPgo=
