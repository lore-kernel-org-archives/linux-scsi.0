From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 18:16:39 +0000
Message-ID: <3CE2B08B-07F4-411D-B87A-18F586F5534C@cavium.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
 <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com>
 <1509473546.12927.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509473546.12927.5.camel@wdc.com>
Content-Language: en-US
Content-ID: <AA8CF4D8937E184C9CB4D7C6AAE703FA@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "keescook@chromium.org" <keescook@chromium.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org

SGkgQmFydCwgDQoNCj4gT24gT2N0IDMxLCAyMDE3LCBhdCAxMToxMiBBTSwgQmFydCBWYW4gQXNz
Y2hlIDxiYXJ0LnZhbmFzc2NoZUB3ZGMuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgMjAxNy0x
MC0zMSBhdCAxODowMyArMDAwMCwgTWFkaGFuaSwgSGltYW5zaHUgd3JvdGU6DQo+PiBPbiBPY3Qg
MzEsIDIwMTcsIGF0IDg6NDkgQU0sIE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20+IHdyb3RlOg0KPj4+PiBJbiBwcmVwYXJhdGlvbiBmb3IgdW5jb25kaXRpb25h
bGx5IHBhc3NpbmcgdGhlIHN0cnVjdCB0aW1lcl9saXN0DQo+Pj4+IHBvaW50ZXIgdG8gYWxsIHRp
bWVyIGNhbGxiYWNrcywgc3dpdGNoIHRvIHVzaW5nIHRoZSBuZXcgdGltZXJfc2V0dXAoKQ0KPj4+
PiBhbmQgZnJvbV90aW1lcigpIHRvIHBhc3MgdGhlIHRpbWVyIHBvaW50ZXIgZXhwbGljaXRseS4N
Cj4+PiANCj4+PiBDYXZpdW0gZm9sa3M6IFBsZWFzZSB2ZXJpZnkhDQo+PiANCj4+IEnigJl2ZSBj
aGVja2VkIG9uIG15IHNldHVwIGFuZCBpIGFtIHNlZWluZyByZWdyZXNzaW9uIHdpdGggdGhpcyBw
YXRjaCBhcHBsaWVkLiANCj4+IA0KPj4gRHJpdmVyIGxvYWQgbG9ja3MgdXAgdGhlIHN5c3RlbSB3
aXRoIHRoaXMgcGF0Y2ggYXBwbGllZC4gDQo+PiANCj4+IE5BQ0sgDQo+IA0KPiBUaGF0IGZlZWRi
YWNrIGlzIG5vdCB2ZXJ5IGhlbHBmdWwg4oCmDQo+IA0KDQpIZXJl4oCZcyBteSBzZXR1cCBkZXRh
aWxzDQoNCjQuMTQuMC1yYzcgKyBzY3NpX21pc2MtNC4xNSBxbGEyeHh4IHBhdGNoZXMgZnJvbSBN
YXJ0aW7igJlzIHRyZWUgKyBjdXJyZW50IHBhdGNoLiANCg0KU3lzdGVtIGhhcyAzIGFkYXB0ZXJz
IDhHLzE2Ry8zMkcuIA0KDQo+IEFueXdheSwgd2hhdCBrZXJuZWwgc291cmNlIHRyZWUgZGlkIHlv
dSB1c2UgaW4geW91ciB0ZXN0aW5nPyBJIG1heSBiZSBhYmxlIHRvDQo+IGZyZWUgdXAgc29tZSB0
aW1lIHRvIGxvb2sgaW50byB0aGlzIG15c2VsZi4NCj4gDQo+IEJhcnQuDQoNClRoYW5rcywNCi0g
SGltYW5zaHU=
