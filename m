From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH, RFC] tmscsim: kernel bugzilla bug #2139
Date: Tue, 6 Jul 2004 10:11:05 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0407061002200.2004@poirot.grange>
References: <Pine.LNX.4.60.0406302241200.8236@poirot.grange>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1235175847-1089101465=:2004"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:26826 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263664AbUGFIMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2004 04:12:24 -0400
In-Reply-To: <Pine.LNX.4.60.0406302241200.8236@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Kurt Garloff <garloff@suse.de>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1235175847-1089101465=:2004
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Hi

On Wed, 30 Jun 2004, Guennadi Liakhovetski wrote:

> Short: The attached patch fixes the bug-report #2139 from kernel bugzilla.

I wasn't quite convenient with the previous version of the patch, but I 
just wanted to get it working at first and get some comments as to whether 
the approach (put a workaround vs. blacklisting) is at all valid. Since no 
objections arrived, I guess, nobody minds this small trick. So, I am 
enclosing a reworked patch, which does essentially the same, but has some 
more careful checking, and overall looks saner, than the previous one.

James, please undo the previous version (in case you have already applied 
it) and apply this one instead. Sorry for the double work.

Comments are still welcome:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-1235175847-1089101465=:2004
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-bug2139.2.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.60.0407061011050.2004@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-bug2139.2.patch"

ZGlmZiAtdSBhL2RyaXZlcnMvc2NzaS9zY3NpaW9tLmMgYi9kcml2ZXJzL3Nj
c2kvc2NzaWlvbS5jDQotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaWlvbS5jCVR1
ZSBKdWwgIDYgMDk6NTY6NTEgMjAwNA0KKysrIGIvZHJpdmVycy9zY3NpL3Nj
c2lpb20uYwlUdWUgSnVsICA2IDA5OjQ3OjQyIDIwMDQNCkBAIC04OTAsMTQg
Kzg5MCwyMiBAQA0KIA0KICAgICBpZiAocFNSQiA9PSBwQUNCLT5wVG1wU1JC
KQ0KICAgICB7DQotCWlmIChwRENCKSBwcmludGsgKEtFUk5fRVJSICJEQzM5
MDogcFNSQiA9PSBwVG1wU1JCISAoVGFnUSBFcnJvcj8pICglMDJpLSVpKVxu
IiwNCi0JCQkgIHBEQ0ItPlRhcmdldElELCBwRENCLT5UYXJnZXRMVU4pOw0K
LQllbHNlIHByaW50ayAoS0VSTl9FUlIgIkRDMzkwOiBwU1JCID09IHBUbXBT
UkIhIChUYWdRIEVycm9yPykgKERDQiAwISlcbiIpOw0KKwlpZiAocERDQikN
CisJCXByaW50ayhLRVJOX0VSUiAiREMzOTA6IHBTUkIgPT0gcFRtcFNSQiEg
KFRhZ1EgRXJyb3I/KSAoJTAyaS0laSlcbiIsIHBEQ0ItPlRhcmdldElELCBw
RENCLT5UYXJnZXRMVU4pOw0KKwllbHNlDQorCQlwcmludGsoS0VSTl9FUlIg
IkRDMzkwOiBwU1JCID09IHBUbXBTUkIhIChUYWdRIEVycm9yPykgKERDQiAw
ISlcbiIpOw0KIA0KLQlwU1JCLT5wU1JCRENCID0gcERDQjsNCi0JZGMzOTBf
RW5hYmxlTXNnT3V0X0Fib3J0IChwQUNCLCBwU1JCKTsNCi0JaWYgKHBEQ0Ip
IHBEQ0ItPkRDQkZsYWcgfD0gQUJPUlRfREVWOw0KLQlyZXR1cm47DQorCS8q
IFRyeSB0byByZWNvdmVyIC0gc29tZSBicm9rZW4gZGlza3MgcmVhY3QgYmFk
bHkgdG8gdGFnZ2VkIElOUVVJUlkgKi8NCisJaWYgKHBEQ0IgJiYgcEFDQi0+
c2Nhbl9kZXZpY2VzICYmIHBEQ0ItPkdvaW5nU1JCQ250ID09IDEpIHsNCisJ
CXBTUkIgPSBwRENCLT5wR29pbmdTUkI7DQorCQlwRENCLT5wQWN0aXZlU1JC
ID0gcFNSQjsNCisJfSBlbHNlIHsNCisJCXBTUkItPnBTUkJEQ0IgPSBwRENC
Ow0KKwkJZGMzOTBfRW5hYmxlTXNnT3V0X0Fib3J0KHBBQ0IsIHBTUkIpOw0K
KwkJaWYgKHBEQ0IpDQorCQkJcERDQi0+RENCRmxhZyB8PSBBQk9SVF9ERVY7
DQorCQlyZXR1cm47DQorCX0NCiAgICAgfQ0KIA0KICAgICBpZiggcFNSQi0+
U0dJbmRleCA8IHBTUkItPlNHY291bnQgKQ0K

---1463811839-1235175847-1089101465=:2004--
