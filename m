From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Tue, 25 Oct 2016 23:18:02 +0000
Message-ID: <1477437481.2385.7.camel@sandisk.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
         <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
         <1477434237.3079.84.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0048.outbound.protection.outlook.com ([104.47.38.48]:36157
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753107AbcJYXdH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 19:33:07 -0400
In-Reply-To: <1477434237.3079.84.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <29D9ECCD9DB7B145B310C76DD12257B0@namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "krisman@linux.vnet.ibm.com" <krisman@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "gabriel@krisman.be" <gabriel@krisman.be>

T24gVHVlLCAyMDE2LTEwLTI1IGF0IDE1OjIzIC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IEJlY2F1c2Ugc2NzaV9leGVjdXRlIHVzZXMgUkVRX0JMT0NLX1BDIHdoaWNoIGlzIGNvbXBs
ZXRlZCBiZWZvcmUgeW91DQo+IGdldCB0byB0aGF0IGNvZGUuDQoNCkhlbGxvIEphbWVzLA0KDQpE
byB5b3UgcGVyaGFwcyBtZWFuIHRoYXQgc2NzaV9pb19jb21wbGV0aW9uKCkgcmV0dXJucyBlYXJs
eSBmb3INClJFUV9UWVBFX0JMT0NLX1BDIHJlcXVlc3RzPyBDYW4geW91IGNsYXJpZnkgdGhpcyBm
dXJ0aGVyPw0KDQpBbnl3YXksIGN1cnJlbnRseSB0aGUgZm9sbG93aW5nIGZ1bmN0aW9ucyBpbnRl
cnByZXQgdGhlIFNDU0kgc2Vuc2UNCmJ1ZmZlcjoNCiogc2NzaV9pb19jb21wbGV0aW9uKCkgaW4g
c2NzaV9saWIuYy4NCiogc2NzaV9tb2RlX3NlbnNlKCkgaW4gc2NzaV9saWIuYy4NCiogc2NzaV90
ZXN0X3VuaXRfcmVhZHlfZmxhZ3MoKSBpbiBzY3NpX2xpYi5jLg0KKiBzY3NpX3Byb2JlX2x1bigp
IGluIHNjc2lfc2Nhbi5jLg0KKiBzY3NpX3JlcG9ydF9sdW5fc2NhbigpIGluIHNjc2lfc2Nhbi5j
Lg0KKiBpb2N0bF9pbnRlcm5hbF9jb21tYW5kKCkgaW4gc2NzaV9pb2N0bC5jLg0KKiBzZ19ycV9l
bmRfaW8oKSBpbiBzZy5jLg0KKiBzY3NpX2NoZWNrX3NlbnNlKCkgaW4gc2NzaV9lcnJvci5jLg0K
KiBzcGlfZXhlY3V0ZSgpIGluIHNjc2lfdHJhbnNwb3J0X3NwaS5jLg0KDQpBcmUgeW91IHN1cmUg
d2Ugc2hvdWxkIGFkZCBzZW5zZSBjb2RlIGludGVycHJldGF0aW9uIGNvZGUgaW4gYSB0ZW50aA0K
ZnVuY3Rpb24gaW4gdGhlIFNDU0kgY29yZT8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
