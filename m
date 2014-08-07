From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 1/3] libsas: modify SATA error handler
Date: Wed, 6 Aug 2014 18:50:48 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D5944CE8DCE@SC-VEXCH4.marvell.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
	<CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D57320C6287@SC-VEXCH4.marvell.com>
	<CAPcyv4g7zMf4UGZPYFk30kh5J_-ot6kuesEjOZJTRbL_UkpQ9g@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D5944CE8C71@SC-VEXCH4.marvell.com>
 <CAPcyv4jSr7O2Qxe-ac9anJUT4KksbdNuCGd=iBFy2CJF8G5Mkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jSr7O2Qxe-ac9anJUT4KksbdNuCGd=iBFy2CJF8G5Mkw@mail.gmail.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "tj@kernel.org" <tj@kernel.org>, "todd.e.brandt@intel.com" <todd.e.brandt@intel.com>, "lukasz.dorau@intel.com" <lukasz.dorau@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

SGksIERhbg0KSSBoYXZlbid0IHJlY2VpdmUgeW91ciByZXZpZXcgY29tbWVudHMsIGNvdWxkIHlv
dSBzZW5kIGl0IHRvIG1lIGFnYWluLCB0aGFua3MhDQpQUzogSSBjYW4ndCBsb2dpbiBteSBnbWFp
bCwgc28gcGxlYXNlIHNlbmQgbWFpbCB0byB0aGlzIGNvdW50Lg0KDQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0bzpkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb21dIA0KU2VudDogMjAxNOW5tDjmnIg35pelIDE6MjINClRvOiBYaWFuZ2xpYW5nIFl1
DQpDYzogSkJvdHRvbWxleUBwYXJhbGxlbHMuY29tOyB0akBrZXJuZWwub3JnOyB0b2RkLmUuYnJh
bmR0QGludGVsLmNvbTsgbHVrYXN6LmRvcmF1QGludGVsLmNvbTsgbGludXgtaWRlQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtc2NzaUB2Z2VyLmtl
cm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBsaWJzYXM6IG1vZGlmeSBTQVRBIGVy
cm9yIGhhbmRsZXINCg0KT24gV2VkLCBBdWcgNiwgMjAxNCBhdCAzOjUwIEFNLCBYaWFuZ2xpYW5n
IFl1IDx5dXhpYW5nbEBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+IEhpLCBEYW4gJiBKYW1lcw0KPiBI
b3cgYWJvdXQgdGhlIHBhdGNoZXMgYWJvdXQgc3VwcG9ydCBmb3IgUE0/DQo+IFR3byBtb250aHMg
aGFkIHBhc3NlZCBzaW5jZSBJIHN1Ym1pdHRlZCB0aGUgcGF0Y2hlcy4NCj4gVGhhbmtzIQ0KPg0K
DQpEaWQgeW91IGFkZHJlc3MgbXkgcmV2aWV3IGNvbW1lbnRzPw0K
