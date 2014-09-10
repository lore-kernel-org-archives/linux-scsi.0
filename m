From: "Sharma, Sanjeev" <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 01/21] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Date: Wed, 10 Sep 2014 11:58:44 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF4918C@EU-MBX-04.mgc.mentorg.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-2-git-send-email-hdegoede@redhat.com>
	 <54103AA3.7000801@redhat.com> <1410350184.12706.18.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410350184.12706.18.camel-B2T3B9s34ElbnMAlSieJcQ@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IE9saXZlciBOZXVrdW0gW21haWx0bzpv
bmV1a3VtQHN1c2UuZGVdIA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMTAsIDIwMTQgNToy
NiBQTQ0KVG86IEhhbnMgZGUgR29lZGUNCkNjOiBHcmVnIEtyb2FoLUhhcnRtYW47IGxpbnV4LXVz
YkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBzdGFibGVAdmdl
ci5rZXJuZWwub3JnOyBTaGFybWEsIFNhbmplZXYNClN1YmplY3Q6IFJlOiBbUEFUQ0ggMDEvMjFd
IHVhczogcmVwbGFjZSBXQVJOX09OX09OQ0UoKSB3aXRoIGxvY2tkZXBfYXNzZXJ0X2hlbGQoKQ0K
DQpPbiBXZWQsIDIwMTQtMDktMTAgYXQgMTM6NDggKzAyMDAsIEhhbnMgZGUgR29lZGUgd3JvdGU6
DQo+IEhpLA0KPiANCj4gTm90ZSB0aGlzIHNlcmllcyBpcyBOT1QgaW50ZW5kZWQgZm9yIHN0YWJs
ZSwgYnV0IEkgYWNjaWRlbnRhbGx5IGhhZCANCj4gImNjID0gc3RhYmxlQHZnZXIua2VybmVsLm9y
ZyIgaW4gbXkgLmdpdC9jb25maWcgd2hlbiBzZW5kaW5nIHRoaXMgDQo+IHNlcmllcywgcGxlYXNl
IGlnbm9yZSBmb3Igc3RhYmxlLg0KPiANCj4gTkFDSyBmb3Igc3RhYmxlLg0KDQpJZiB0aGlzIGlz
IG5vdCBmb3Igc3RhYmxlLCB3aGF0IGRvIHlvdSBpbnRlbmQgdG8gZG8gYWJvdXQgdGhlIHByb2Js
ZW1zIGluIHN0YWJsZT8gRm9yIGV4YW1wbGUgcGF0Y2gjMDEgb2YgdGhpcyBzZXJpZXMgbG9va3Mg
bGlrZSBjbGVhciBzdGFibGUgbWF0ZXJpYWwgdG8gbWUuDQoNCglSZWdhcmRzDQoJCU9saXZlcg0K
DQpUaGlzIGlzIG5vdCBjbGVhciB0byBtZSBhbHNvLiBQbGVhc2UgQ2xhcmlmeSAiTm90ZSB0aGlz
IHNlcmllcyBpcyBOT1QgaW50ZW5kZWQgZm9yIHN0YWJsZSIgIG1lYW5zID8NCg0KUmVnYXJkcw0K
U2FuamVldiBTaGFybWENCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
