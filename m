From: "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>
Subject: RE: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Wed, 22 Oct 2014 22:03:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E557.3010505-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Scales, Webb" <webb.scales-VXdhtT5mjnY@public.gmane.org>, "Don Brace (PMC)" <Don.Brace-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgW21h
aWx0bzpidmFuYXNzY2hlQGFjbS5vcmddDQo+IFNlbnQ6IFR1ZXNkYXksIDA3IE9jdG9iZXIsIDIw
MTQgODowNyBBTQ0KLi4uDQo+IEBAIC0xOTI3LDcgKzE5MzEsNyBAQCBzdGF0aWMgaW50IHNycF9x
dWV1ZWNvbW1hbmQoc3RydWN0IFNjc2lfSG9zdA0KPiAqc2hvc3QsIHN0cnVjdCBzY3NpX2NtbmQg
KnNjbW5kKQ0KPiANCj4gIAljbWQtPm9wY29kZSA9IFNSUF9DTUQ7DQo+ICAJY21kLT5sdW4gICAg
PSBjcHVfdG9fYmU2NCgodTY0KSBzY21uZC0+ZGV2aWNlLT5sdW4gPDwgNDgpOw0KPiAtCWNtZC0+
dGFnICAgID0gcmVxLT5pbmRleDsNCj4gKwljbWQtPnRhZyAgICA9IHRhZzsNCj4gIAltZW1jcHko
Y21kLT5jZGIsIHNjbW5kLT5jbW5kLCBzY21uZC0+Y21kX2xlbik7DQo+IA0KPiAgCXJlcS0+c2Nt
bmQgICAgPSBzY21uZDsNCi4uLg0KPiANCj4gK3N0YXRpYyBpbnQgc3JwX3NsYXZlX2FsbG9jKHN0
cnVjdCBzY3NpX2RldmljZSAqc2RldikNCj4gK3sNCj4gKwlzZGV2LT50YWdnZWRfc3VwcG9ydGVk
ID0gMTsNCj4gKw0KPiArCXNjc2lfYWN0aXZhdGVfdGNxKHNkZXYsIHNkZXYtPnF1ZXVlX2RlcHRo
KTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQoNCkhhdmUgeW91IHRlc3RlZCB0aGlz
IHdpdGggc2NzaV9tb2QudXNlX2Jsa19tcT1uPw0KDQpUcnlpbmcgc2ltaWxhciBjaGFuZ2VzIGlu
IGhwc2EsIHdlIHN0aWxsIHJlY2VpdmUgc29tZSBJTlFVSVJZIGNvbW1hbmRzIA0Kc3VibWl0dGVk
IHRocm91Z2ggcXVldWVjb21tYW5kIHdpdGggdGFnIC0xLiAgVGhleSBhcmUgZm9yIGRldmljZXMg
Zm9yDQp3aGljaCBzbGF2ZV9hbGxvYyBoYXMgbm90IHlldCBiZWVuIHJ1biwgaW1wbHlpbmcgdGhp
cyB3b3JrIG5lZWRzIHRvIA0KYmUgZG9uZSBldmVuIGVhcmxpZXIuICBNYXliZSB0aGUgbWlkbGF5
ZXIgaXMgbWlzc2luZyBhIHNsYXZlX2FsbG9jDQpjYWxsIHNvbWV3aGVyZT8NCg0KLS0tDQpSb2Ig
RWxsaW90dCAgICBIUCBTZXJ2ZXIgU3RvcmFnZQ0KDQoNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
