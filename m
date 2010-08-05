From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Thu, 5 Aug 2010 14:44:19 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DBD67FC4@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
	 <1277066924.5242.41.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
 <1280598371.2801.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47080 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759391Ab0HEUoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 16:44:34 -0400
In-Reply-To: <1280598371.2801.11.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Maharana, Parag" <Parag.Maharana@lsi.com>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

SmFtZXMsDQoNCkkgcmUtc3VibWl0dGVkIGFsbCAxMiBwYXRjaGVzLiAgQ2FuIHlvdSBoZWxwIHRv
IHB1c2ggdGhlbSB0byBtYWluIHRyZWU/DQoNClRoYW5rcywNCg0KQm8gWWFuZw0KDQotLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmFtZXMgQm90dG9tbGV5IFttYWlsdG86SmFtZXMu
Qm90dG9tbGV5QHN1c2UuZGVdIA0KU2VudDogU2F0dXJkYXksIEp1bHkgMzEsIDIwMTAgMTo0NiBQ
TQ0KVG86IFlhbmcsIEJvDQpDYzogWWluZ2hhaSBMdTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5v
cmc7IGFrcG1Ab3NkbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IE1haGFyYW5h
LCBQYXJhZzsgRGFmdGFyZGFyLCBKYXlhbnQNClN1YmplY3Q6IFJFOiBbUEFUQ0ggMS8xMl0gc2Nz
aTogbWVnYXJhaWRfc2FzIC0gT25saW5lIENvbnRyb2xsZXIgUmVzZXQgLSBJOiBFbmFibGUgT25s
aW5lIENvbnRyb2xsZXIgUmVzZXQgQml0IGluIHJlZ2lzdGVyIHJlbGF0ZWQgZnVuY3Rpb25zDQoN
Ck9uIEZyaSwgMjAxMC0wNy0zMCBhdCAxMjo1MyAtMDYwMCwgWWFuZywgQm8gd3JvdGU6DQo+IERv
IHlvdSBrbm93IHdoZW4gdGhvc2UgcGF0Y2hlcyAoMTIgcGF0Y2hlcykgd2lsbCBiZSBwdXNoZWQg
dG8gdXBzdHJlYW0/DQoNCldlbGwsIGl0IGxvb2tzIGxpa2UgSSBsb3N0IHRoZSBicmFuY2ggSSB3
YXMgZml4aW5nIGFsbCB0aGlzIHVwIGluDQpzb21ld2hlcmUuICBJIGRvbid0IHJlYWxseSBoYXZl
IHRpbWUgdG8gcmVkbyB0aGF0IHdvcmssIHNvIGNvdWxkIHlvdQ0Kc2VuZCB0aGUgc2VyaWVzIGNv
cnJlY3RseSAodGhhdCdzIHRoZSA4IE9DUiBwYXRjaGVzIHRoYXQgZG9uJ3QNCmluZGl2aWR1YWxs
eSBjb21waWxlIGFzIGEgc2luZ2xlIHBhdGNoIHdpdGggYSBjb3JyZWN0IGNoYW5nZWxvZyBwbHVz
IHRoZQ0KZm91ciBvdGhlcnMpLg0KDQpUaGFua3MsDQoNCkphbWVzDQoNCg0K
