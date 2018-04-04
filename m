From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] sd_zbc: Avoid errors due to sd_zbc_setup() execution
Date: Wed, 4 Apr 2018 15:22:19 +0000
Message-ID: <0c4335c249964000ecd94acbc27e9e58aaff6f7e.camel@wdc.com>
References: <20180404085418.29205-1-damien.lemoal@wdc.com>
         <20180404085418.29205-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404085418.29205-3-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <E2695A2E3E7C1847AE6329362656EDF8@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTA0LTA0IGF0IDE3OjU0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gU2luY2UgU0NTSSBzY2FubmluZyBvY2N1cnMgYXN5bmNocm9ub3VzbHksIHNpbmNlIHNkX3Jl
dmFsaWRhdGVfZGlzaygpDQo+IGlzIGNhbGxlZCBmcm9tIHNkX3Byb2JlX2FzeW5jKCkgYW5kIHNp
bmNlIHNkX3JldmFsaWRhdGVfZGlzaygpIGNhbGxzDQo+IHNkX3piY19yZWFkX3pvbmVzKCkgaXQg
Y2FuIGhhcHBlbiB0aGF0IHNkX3piY19yZWFkX3pvbmVzKCkgaXMgY2FsbGVkDQo+IGNvbmN1cnJl
bnRseSB3aXRoIG9wZXJhdGlvbnMgcmVmZXJlbmNpbmcgYSBkcml2ZSB6b25lIGJpdG1hcHMgYW5k
IG51bWJlcg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5e
Xl5eXl5eXl5eXl5eXl5eDQoNClNob3VsZCAiYSIgYmUgY2hhbmdlZCBpbnRvICJ0aGUiPw0KDQo+
IFtEYW1pZW5dIFVwZGF0ZWQgY29tbWl0IG1lc3NhZ2UgYW5kIGNoYW5nZWQgbnJfem9uZXMvYml0
bWFwIHN3YXAgb3JkZXIuDQoNClVwZGF0aW5nIHRoZSBudW1iZXIgb2Ygem9uZXMgYWZ0ZXIgaGF2
aW5nIHVwZGF0ZWQgdGhlIGJpdG1hcCBwb2ludGVycyBpcyBub3QNCnN1ZmZpY2llbnQgdG8gYXZv
aWQgdHJvdWJsZSBpZiB0aGUgbnVtYmVyIG9mIHpvbmVzIGFzIHJlcG9ydGVkIGJ5IHRoZSBkcml2
ZQ0KY2hhbmdlcyB3aGlsZSBJL08gaXMgaW4gcHJvZ3Jlc3MuIFdpdGggdGhlIGN1cnJlbnQgaW1w
bGVtZW50YXRpb24gaWYgdGhlDQpudW1iZXIgb2Ygem9uZXMgY2hhbmdlcyB0aGUgc2VxX3pvbmVz
X2JpdG1hcCBpcyBjbGVhcmVkLiBDYW4gdGhpcyBjYXVzZQ0KdHJvdWJsZSBmb3IgdGhlIG1xLWRl
YWRsaW5lIHNjaGVkdWxlcj8gQWRkaXRpb25hbGx5LCBDUFVzIG90aGVyIHRoYW4geDg2IGNhbg0K
cmVvcmRlciBzdG9yZSBvcGVyYXRpb25zLiBFdmVuIHdvcnNlLCBhIENQVSBjb3VsZCBjYWNoZSB0
aGUgem9uZSBiaXRtYXANCnBvaW50ZXJzIHdoaWNoIG1lYW5zIHRoYXQgYXQgbGVhc3QgUkNVIHBy
b3RlY3Rpb24gKyBrZnJlZV9yY3UoKSBpcyBuZWVkZWQgdG8NCmF2b2lkIHRyb3VibGUuIEkgdGhp
bmsgd2UgZWl0aGVyIHNob3VsZCBoYW5kbGUgdGhpcyBjYXNlIHByb3Blcmx5IG9yIGlzc3VlIGEN
Cmtlcm5lbCB3YXJuaW5nLg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0K
