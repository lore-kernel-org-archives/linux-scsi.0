From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: RE: [PATCH 1/3] pm8001: fix pm8001_store_update_fw
Date: Wed, 30 Jul 2014 12:22:01 +0000
Message-ID: <CE2C58F938F4C44EA74FFF880BAA7E5E49DC87FD@BBYEXM02.pmc-sierra.internal>
References: <1406721810-4591-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
 <1406722208.4865.57.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:35381 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbaG3MVx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:21:53 -0400
In-Reply-To: <1406722208.4865.57.camel@jarvis>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "xjtuwjp@gmail.com" <xjtuwjp@gmail.com>, "thenzl@redhat.com" <thenzl@redhat.com>, Viswas G <Viswas.G@pmcs.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>

DQoNCk9uIFdlZCwgSnVsIDMwLCAyMDE0IGF0IDU6NDAgUE0sIEphbWVzIEJvdHRvbWxleSA8SmFt
ZXMuQm90dG9tbGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbT4gd3JvdGU6DQo+IE9uIFdlZCwgMjAx
NC0wNy0zMCBhdCAxNzozMyArMDUzMCwgU3VyZXNoIFRoaWFnYXJhamFuIHdyb3RlOg0KPj4gRnJv
bTogU3VyZXNoIFRoaWFnYXJhamFuIDxTdXJlc2guVGhpYWdhcmFqYW5AcG1jcy5jb20+DQo+Pg0K
Pj4gVGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gbWF5IG1peCB0aGUgbmVnYXRpdmUgdmFsdWUg
cmV0dXJuZWQNCj4+IGZyb20gcG04MDAxX3NldF9udm1kIHdpdGggd2l0aCBjb3VudC4gLSgtRU5P
TUVNKSBjb3VsZCBiZSBpbnRlcnByZXRlZA0KPj4gYXMgYnl0ZXMgcHJvZ3JhbW1lZCwgdGhpcyBw
YXRjaCBmaXhlcyBpdC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUb21hcyBIZW56bCA8dGhlbnps
QHJlZGhhdC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTdXJlc2ggVGhpYWdhcmFqYW4gPFN1cmVz
aC5UaGlhZ2FyYWphbkBwbWNzLmNvbT4NCj4NCj4gVGhpcyBhdXRob3IgYW5kIHNpZ25vZmYgY2hh
aW4gZG9lc24ndCBtYWtlIHNlbnNlLiAgSXMgdGhlIHBhdGNoIGZyb20NCj4gVG9tYXMgSGVuemw/
ICBJbiB3aGljaCBjYXNlIHRoZSBGcm9tOiBmaWVsZCBpcyB3cm9uZzsgaXQgc2hvdWxkIHJlYWQN
Cj4NCj4gRnJvbTogVG9tYXMgSGVuemwgPHRoZW56bEByZWRoYXQuY29tPg0KDQpZZXMuIFRoaXMg
cGF0Y2ggaXMgZnJvbSBUb21hcy4gSSB3aWxsIGNvcnJlY3QgdGhlICJGcm9tIiBhbmQgc2VuZCBh
Z2Fpbg0KDQotU3VyZXNoDQo+DQo+IEphbWVzDQo+DQo+DQo+IC0tDQo+IFRvIHVuc3Vic2NyaWJl
IGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZSBsaW51eC1zY3NpIiBp
bg0KPiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZw0K
PiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9t
by1pbmZvLmh0bWwNCg==
