From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Sun, 20 Jun 2010 14:19:36 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
 <1277063250.5242.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40974 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757025Ab0FTUTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 16:19:48 -0400
In-Reply-To: <1277063250.5242.25.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

SmFtZXMsDQoNClllcy4gIA0KDQpSZWdhcmRzLA0KDQpCbyBZYW5nDQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21haWx0bzpKYW1lcy5Cb3R0b21s
ZXlAc3VzZS5kZV0gDQpTZW50OiBTdW5kYXksIEp1bmUgMjAsIDIwMTAgMzo0OCBQTQ0KVG86IFlh
bmcsIEJvDQpDYzogWWluZ2hhaSBMdTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGFrcG1A
b3NkbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJFOiBbUEFU
Q0ggMS8xMl0gc2NzaTogbWVnYXJhaWRfc2FzIC0gT25saW5lIENvbnRyb2xsZXIgUmVzZXQgLSBJ
OiBFbmFibGUgT25saW5lIENvbnRyb2xsZXIgUmVzZXQgQml0IGluIHJlZ2lzdGVyIHJlbGF0ZWQg
ZnVuY3Rpb25zDQoNCk9uIFN1biwgMjAxMC0wNi0yMCBhdCAxMzoyNyAtMDYwMCwgWWFuZywgQm8g
d3JvdGU6DQo+IFRoZSBvbmxpbmUgY29udHJvbGxlciByZXNldCAoT0NSKSBuZWVkIHRvIGFwcGx5
IFtQYXRjaCAxLzEyICAtLSAgcGF0Y2gNCj4gOC8xMl0uICBJIGFscmVhZHkgc3VibWl0dGVkIGFs
bCBvZiB0aGVtLg0KDQpTbyAxLTggaGF2ZSB0byBiZSBkb25lIGFzIGEgc2luZ2xlIGNvbW1pdCBh
bmQgOS0xMiBjYW4gYXBwbHkNCmluZGl2aWR1YWxseT8NCg0KSmFtZXMNCg0KDQo=
