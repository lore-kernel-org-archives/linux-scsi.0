From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH] qla2xxx: setup data needed in ISR before setting up the
 ISR
Date: Thu, 14 Jul 2016 13:50:05 +0000
Message-ID: <08FEBBBA-97F8-4AA0-A821-AE73A5D27114@qlogic.com>
References: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
 <yq14m7slu6i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14m7slu6i.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Content-ID: <02E1F19502900346828F34B027168E02@namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

DQoNCk9uIDcvMTMvMTYsIDk6MjggUE0sICJNYXJ0aW4gSy4gUGV0ZXJzZW4iIDxtYXJ0aW4ucGV0
ZXJzZW5Ab3JhY2xlLmNvbT4gd3JvdGU6DQoNCj4+Pj4+PiAiSm9oYW5uZXMiID09IEpvaGFubmVz
IFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPiB3cml0ZXM6DQo+DQo+Sm9oYW5uZXM+IHFs
YTJ4eHggZmlyc3QgY2FsbHMgcmVxdWVzdF9pcnEoKSBhbmQgdGhlbiBkb2VzIHRoZSBzZXR1cCBv
Zg0KPkpvaGFubmVzPiB0aGUgcXVldWUgZW50cnkgZGF0YSBuZWVkZWQgaW4gdGhlIGludGVycnVw
dCBoYW5kbGVycyBpbiB3aGVuDQo+Sm9oYW5uZXM+IHVzaW5nIE1TSS1YLiBUaGlzIGNvdWxkIGxl
YWQgdG8gYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UNCj5Kb2hhbm5lcz4gd2hlbiBhbiBJUlEg
ZmlyZXMgYmV0d2VlbiB0aGUgcmVxdWVzdF9pcnEoKSBjYWxsIGFuZCB0aGUNCj5Kb2hhbm5lcz4g
YXNzaWdubWVudCBvZiB0aGUgcWVudHJ5IGRhdGEgc3RydWN0dXJlIHRvIHRoZQ0KPnJzcC0+IG1z
aXggZmllbGQuIEEgcG9zc2libGUgY2FzZSBmb3Igc3VjaCBhIHJhY2Ugd291bGQgYmUgaW4gdGhl
IGtkdW1wDQo+Sm9oYW5uZXM+IGNhc2Ugd2hlbiB0aGUgSEJBJ3MgSVJRcyBhcmUgc3RpbGwgZW5h
YmxlZCBidXQgdGhlIGRyaXZlciBpcw0KPkpvaGFubmVzPiB1bmRlcmdvaW5nIGEgbmV3IGluaXRp
YWxpc2F0aW9uIGFuZCB0aHVzIGlzIG5vdCBhd2FyZSBvZg0KPkpvaGFubmVzPiBhbHJlYWR5IGFj
dGl2YXRlZCBJUlFzIGluIHRoZSBIQkEuDQo+DQo+UWxvZ2ljIGZvbGtzOiBQbGVhc2UgcmV2aWV3
IQ0KDQpMb29rcyBHb29kLiANCg0KUmV2aWV3ZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhpbWFu
c2h1Lm1hZGhhbmlAcWxvZ2ljLmNvbT4NCg0KDQo+DQo+LS0gDQo+TWFydGluIEsuIFBldGVyc2Vu
CU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0K
