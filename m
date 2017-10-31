From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 18:03:45 +0000
Message-ID: <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d153b9lt.fsf@oracle.com>
Content-Language: en-US
Content-ID: <33EE0586A9938A40B740592F279D7000@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

SGkgTWFydGluL0tlZXMsIA0KDQo+IE9uIE9jdCAzMSwgMjAxNywgYXQgODo0OSBBTSwgTWFydGlu
IEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiAN
Cj4gS2VlcywNCj4gDQo+PiBJbiBwcmVwYXJhdGlvbiBmb3IgdW5jb25kaXRpb25hbGx5IHBhc3Np
bmcgdGhlIHN0cnVjdCB0aW1lcl9saXN0DQo+PiBwb2ludGVyIHRvIGFsbCB0aW1lciBjYWxsYmFj
a3MsIHN3aXRjaCB0byB1c2luZyB0aGUgbmV3IHRpbWVyX3NldHVwKCkNCj4+IGFuZCBmcm9tX3Rp
bWVyKCkgdG8gcGFzcyB0aGUgdGltZXIgcG9pbnRlciBleHBsaWNpdGx5Lg0KPiANCj4gQ2F2aXVt
IGZvbGtzOiBQbGVhc2UgdmVyaWZ5IQ0KPiANCg0KSeKAmXZlIGNoZWNrZWQgb24gbXkgc2V0dXAg
YW5kIGkgYW0gc2VlaW5nIHJlZ3Jlc3Npb24gd2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQuIA0KDQpE
cml2ZXIgbG9hZCBsb2NrcyB1cCB0aGUgc3lzdGVtIHdpdGggdGhpcyBwYXRjaCBhcHBsaWVkLiAN
Cg0KTkFDSyANCg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0
ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gDQo+IC0tIA0KPiBNYXJ0aW4gSy4gUGV0ZXJzZW4JT3JhY2xl
IExpbnV4IEVuZ2luZWVyaW5nDQoNClRoYW5rcywNCi0gSGltYW5zaHUNCg0K
