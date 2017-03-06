From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: RE: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Mon, 6 Mar 2017 05:05:16 +0000
Message-ID: <SN1PR0701MB1837AA21084AFDD5E5FB5B69F52C0@SN1PR0701MB1837.namprd07.prod.outlook.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
 <1488760974.2808.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0077.outbound.protection.outlook.com ([104.47.34.77]:38115
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753119AbdCFFFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 00:05:52 -0500
In-Reply-To: <1488760974.2808.1.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAc2FuZGlzay5jb21dDQo+IFNlbnQ6IFN1bmRheSwgTWFy
Y2ggNSwgMjAxNyA0OjQzIFBNDQo+IFRvOiBNYWRoYW5pLCBIaW1hbnNodSA8SGltYW5zaHUuTWFk
aGFuaUBjYXZpdW0uY29tPjsgdGFyZ2V0LQ0KPiBkZXZlbEB2Z2VyLmtlcm5lbC5vcmc7IG5hYkBs
aW51eC1pc2NzaS5vcmcNCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBNYWxhdmFs
aSwgR2lyaWRoYXINCj4gPEdpcmlkaGFyLk1hbGF2YWxpQGNhdml1bS5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjMgMDAvMTRdIHFsYTJ4eHg6IEJ1ZyBGaXhlcyBhbmQgdXBkYXRlcyBmb3Ig
dGFyZ2V0Lg0KPiANCj4gT24gRnJpLCAyMDE3LTAyLTI0IGF0IDEzOjM3IC0wODAwLCBIaW1hbnNo
dSBNYWRoYW5pIHdyb3RlOg0KPiA+IFBsZWFzZSBjb25zaWRlciB0aGlzIHNlcmllcyBmb3IgaW5j
bHVzaW9uIGluIHRhcmdldC1wZW5kaW5nLg0KPiANCj4gSGVsbG8gSGltYW5zaHUsDQo+IA0KPiBJ
IGFwcGxpZWQgdGhpcyBwYXRjaCBzZXJpZXMgb24gdG9wIG9mIGtlcm5lbCB2NC4xMS1yYzEgYW5k
IGluc3RhbGxlZCBpdCBvbiBhIHRlc3QNCj4gc3lzdGVtLiBVbmZvcnR1bmF0ZWx5IHRoZSByZWdy
ZXNzaW9uIEkgcmVwb3J0ZWQgb25lIG1vbnRoIGFnbyBhZ2FpbnN0DQo+IHYyIG9mIHRoaXMgcGF0
Y2ggc2VyaWVzIHN0aWxsIG9jY3VycyB3aXRoIHYzIG9mIHRoaXMgcGF0Y2ggc2VyaWVzOg0KPiAN
Cj4gSU5GTzogdGFzayBrd29ya2VyLzI6MTo3MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNl
Y29uZHMuDQo+ICAgICAgIE5vdCB0YWludGVkIDQuMTEuMC1yYzEtZGJnKyAjMQ0KPiAiZWNobyAw
ID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlz
IG1lc3NhZ2UuDQo+IGt3b3JrZXIvMjoxICAgICBEICAgIDAgICAgNzEgICAgICAyIDB4MDAwMDAw
MDANCj4gV29ya3F1ZXVlOiBldmVudHMgcWx0X2ZyZWVfc2Vzc2lvbl9kb25lIFtxbGEyeHh4XSBD
YWxsIFRyYWNlOg0KPiAgX19zY2hlZHVsZSsweDFlZi8weGE3MA0KPiAgc2NoZWR1bGUrMHg0MC8w
eDkwDQo+ICBzY2hlZHVsZV90aW1lb3V0KzB4MjU4LzB4NGEwDQo+ICB3YWl0X2Zvcl9jb21wbGV0
aW9uKzB4MTA4LzB4MTcwDQo+ICB0YXJnZXRfd2FpdF9mb3Jfc2Vzc19jbWRzKzB4NTYvMHgxYjAg
W3RhcmdldF9jb3JlX21vZF0NCj4gIHRjbV9xbGEyeHh4X2ZyZWVfc2Vzc2lvbisweDQ1LzB4OTAg
W3RjbV9xbGEyeHh4XQ0KPiAgcWx0X2ZyZWVfc2Vzc2lvbl9kb25lKzB4NDRhLzB4NTUwIFtxbGEy
eHh4XQ0KPiAgcHJvY2Vzc19vbmVfd29yaysweDIwZC8weDZjMA0KPiAgd29ya2VyX3RocmVhZCsw
eDRlLzB4NGEwDQo+ICBrdGhyZWFkKzB4MTBjLzB4MTQwDQo+ICByZXRfZnJvbV9mb3JrKzB4MzEv
MHg0MA0KPiANCj4gQmFydA0KDQpXZSdsbCB0YWtlIGEgbG9vay4NCg==
