From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [patch] qla2xxx: small cleanup in qla2x00_wait_for_hba_ready()
Date: Thu, 4 Aug 2016 22:20:39 +0000
Message-ID: <7AF62168-5A35-4B9A-9F3F-CEE3A9E8F7F7@qlogic.com>
References: <20160803184232.GA775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0113.outbound.protection.outlook.com ([104.47.37.113]:6592
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934717AbcHDXz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 19:55:26 -0400
In-Reply-To: <20160803184232.GA775@mwanda>
Content-Language: en-US
Content-ID: <5B2ADDDB8189D849AE89B22A5E03B08E@namprd11.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

DQpPbiA4LzMvMTYsIDExOjQyIEFNLCAiRGFuIENhcnBlbnRlciIgPGRhbi5jYXJwZW50ZXJAb3Jh
Y2xlLmNvbT4gd3JvdGU6DQoNCj5UaGUgImlmICh0ZXN0X2JpdChVTkxPQURJTkcuLi4iIGxpbmUg
d2FzIGluZGVudGVkIG9uZSB0YWIgbW9yZSB0aGFuIGl0DQo+c2hvdWxkIGhhdmUgYmVlbi4gIFRo
ZXJlIHdhcyBhbiBleHRyYSBwYXJlbnRoZXNpcyBhcm91bmQgdGhlDQo+cWxhMngwMF9yZXNldF9h
Y3RpdmUoKSBmdW5jdGlvbiBjYWxsLiAgSSBsaW5lZCB1cCB0aGUgY29uZGl0aW9ucyBhIGJpdA0K
PnNvIHRoYXQgaXQgc2hvd3MgaG93IHRoZXkgZ3JvdXAgdG9nZXRoZXIuDQo+DQo+U2lnbmVkLW9m
Zi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPg0KPmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYyBiL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9vcy5jDQo+aW5kZXggMjY3NGY0Yy4uMWRkODY1MCAxMDA2NDQNCj4tLS0gYS9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KPisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9vcy5jDQo+QEAgLTg5OSwxMiArODk5LDEyIEBAIHFsYTJ4MDBfd2FpdF9mb3JfaGJhX3JlYWR5
KHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiAJc3RydWN0IHFsYV9od19kYXRhICpoYSA9IHZoYS0+
aHc7DQo+IAlzY3NpX3FsYV9ob3N0X3QgKmJhc2VfdmhhID0gcGNpX2dldF9kcnZkYXRhKGhhLT5w
ZGV2KTsNCj4gDQo+LQl3aGlsZSAoKChxbGEyeDAwX3Jlc2V0X2FjdGl2ZSh2aGEpKSB8fCBoYS0+
ZHBjX2FjdGl2ZSB8fA0KPi0JICAgIGhhLT5mbGFncy5tYm94X2J1c3kpIHx8DQo+LQkJdGVzdF9i
aXQoRlgwMF9SRVNFVF9SRUNPVkVSWSwgJnZoYS0+ZHBjX2ZsYWdzKSB8fA0KPi0JCXRlc3RfYml0
KEZYMDBfVEFSR0VUX1NDQU4sICZ2aGEtPmRwY19mbGFncykpIHsNCj4tCQkJaWYgKHRlc3RfYml0
KFVOTE9BRElORywgJmJhc2VfdmhhLT5kcGNfZmxhZ3MpKQ0KPi0JCQkJYnJlYWs7DQo+Kwl3aGls
ZSAoKHFsYTJ4MDBfcmVzZXRfYWN0aXZlKHZoYSkgfHwgaGEtPmRwY19hY3RpdmUgfHwNCj4rCQlo
YS0+ZmxhZ3MubWJveF9idXN5KSB8fA0KPisJICAgICAgIHRlc3RfYml0KEZYMDBfUkVTRVRfUkVD
T1ZFUlksICZ2aGEtPmRwY19mbGFncykgfHwNCj4rCSAgICAgICB0ZXN0X2JpdChGWDAwX1RBUkdF
VF9TQ0FOLCAmdmhhLT5kcGNfZmxhZ3MpKSB7DQo+KwkJaWYgKHRlc3RfYml0KFVOTE9BRElORywg
JmJhc2VfdmhhLT5kcGNfZmxhZ3MpKQ0KPisJCQlicmVhazsNCj4gCQltc2xlZXAoMTAwMCk7DQo+
IAl9DQo+IH0NCg0KTG9va3MgR29vZC4NCg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhp
bWFuc2h1Lm1hZGhhbmlAcWxvZ2ljLmNvbT4NCj4NCg==
