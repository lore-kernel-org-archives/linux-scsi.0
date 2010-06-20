From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
  Enable Online Controller Reset Bit in register related functions
Date: Sun, 20 Jun 2010 13:27:01 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
 <1277046060.5242.18.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58603 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab0FTT1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 15:27:19 -0400
In-Reply-To: <1277046060.5242.18.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Yinghai Lu <yinghai@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

SmFtZXMsDQoNClRoZSBvbmxpbmUgY29udHJvbGxlciByZXNldCAoT0NSKSBuZWVkIHRvIGFwcGx5
IFtQYXRjaCAxLzEyICAtLSAgcGF0Y2ggOC8xMl0uICBJIGFscmVhZHkgc3VibWl0dGVkIGFsbCBv
ZiB0aGVtLg0KDQpSZWdhcmRzLA0KDQpCbyBZYW5nDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21haWx0bzpKYW1lcy5Cb3R0b21sZXlAc3VzZS5k
ZV0gDQpTZW50OiBTdW5kYXksIEp1bmUgMjAsIDIwMTAgMTE6MDEgQU0NClRvOiBZaW5naGFpIEx1
DQpDYzogWWFuZywgQm87IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBha3BtQG9zZGwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTogW1BBVENIIDEvMTJd
IHNjc2k6IG1lZ2FyYWlkX3NhcyAtIE9ubGluZSBDb250cm9sbGVyIFJlc2V0IC0gSTogRW5hYmxl
IE9ubGluZSBDb250cm9sbGVyIFJlc2V0IEJpdCBpbiByZWdpc3RlciByZWxhdGVkIGZ1bmN0aW9u
cw0KDQpPbiBGcmksIDIwMTAtMDYtMTggYXQgMTQ6MTggLTA3MDAsIFlpbmdoYWkgTHUgd3JvdGU6
DQo+IE9uIFdlZCwgSnVuIDksIDIwMTAgYXQgNzozNCBQTSwgWWFuZywgQm8gPEJvLllhbmdAbHNp
LmNvbT4gd3JvdGU6DQo+ID4gRW5hYmxlIHRoZSBPbmxpbmUgQ29udHJvbGxlciByZXNldCBiaXQg
aW4gdGhlIHJlZ2lzdGVyIHJlbGF0ZWQgZnVuY3Rpb25zLiAgVGhpcyBpcyBmaXJzdCBwYXJ0IG9m
IHRoZSBPbmxpbmUgQ29udHJvbGxlciBSZXNldC4NCj4gPiBUaGUgZHJpdmVyIHN1cHBvcnRzIFhT
Y2xlIGFuZCBHZW4yIGNoaXBzLiAgRHJpdmVyIG5lZWQgdG8gcmVhZCB0aGUgRlcgc3RhdGUgcmVn
aXN0ZXIgdG8gc2VlIGlmIHRoZXJlIGlzIEZXIHN0YXRlIGNoYW5nZQ0KPiA+IEhhcHBlbi4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnkgQm8gWWFuZzxiby55YW5nQGxzaS5jb20+DQo+IA0KPiBUaGlz
IHBhdGNoIGNhdXNlIGtlcm5lbCBoYW5nIGp1c3QgYWZ0ZXINCj4gWyAgMTM2Ljk5NjI5N10gbWVn
YXNhczogRlcgbm93IGluIFJlYWR5IHN0YXRlDQoNCk9LLCBJIGRyb3BwZWQgYWxsIHRoZSBtZWdh
cmFpZF9zYXMgcGF0Y2hlcyBmb3Igbm93IC4uLiBJJ2xsIHJlYXBwbHkgb25jZQ0Kd2UgZ2V0IHRo
ZSBiaXNlY3Rpb24gaW50ZXJ2YWxzIHNvcnRlZCBvdXQuDQoNCkphbWVzDQoNCg0K
