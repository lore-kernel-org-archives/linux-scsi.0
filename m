From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFTesters] Re: [PATCH] refactor tmscsim inititalization code
Date: Mon, 20 Sep 2004 22:35:23 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409202228500.6785@poirot.grange>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
 <20040910133254.GB32530@lst.de> <Pine.LNX.4.60.0409172052230.31193@poirot.grange>
 <20040920152450.GA27419@lst.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1537914030-1095712523=:6785"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:55708 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267365AbUITVhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 17:37:13 -0400
In-Reply-To: <20040920152450.GA27419@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1537914030-1095712523=:6785
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Mon, 20 Sep 2004, Christoph Hellwig wrote:

>> Ok, now, that the patch has been applied, and, as Christoph informed me,
>> it would be difficult (impossible?) to undo it, we have to fix it. I'll
>> explain my doubts separately as a reply to another Christoph's email. Or
>> would it still be possible to get a patch in, reverting the EEPROM rework?
>
> might be best to just revert it, I'll cook up a patch.

Why? Would be a pity. I think, the only thing that's needed is the 
attached micro-patch. Chiaki Ishikawa volunteered to test your patch, so, 
I could send him this fix too for a check.

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-1537914030-1095712523=:6785
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-ch_10-fix.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.60.0409202235230.6785@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-ch_10-fix.patch"

LS0tIGEvZHJpdmVycy9zY3NpL3Rtc2NzaW0uYwlNb24gU2VwIDIwIDIyOjEy
OjA1IDIwMDQNCisrKyBiL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJTW9uIFNl
cCAyMCAyMjoxNjo0MyAyMDA0DQpAQCAtOTkxLDIzICs5OTEsMjAgQEANCiAN
CiBzdGF0aWMgdm9pZCBfX2RldmluaXQgZGMzOTBfZWVwcm9tX3ByZXBhcmVf
cmVhZChzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdTggY21kKQ0KIHsNCi0JdTgg
Y2FycnlGbGFnID0gMSwgaiA9IDB4ODAsIGksIGJ2YWwsIHJlZ3ZhbDsNCisJ
dTggY2FycnlGbGFnID0gMSwgaiA9IDB4ODAsIGksIGJ2YWw7DQogDQogCWZv
ciAoaSA9IDA7IGkgPCA5OyBpKyspIHsNCiAJCWlmIChjYXJyeUZsYWcpIHsN
CiAJCQlidmFsID0gMHg0MDsNCi0JCQlyZWd2YWwgPSAweDgwOw0KIAkJDQot
CQkJcGNpX3dyaXRlX2NvbmZpZ19ieXRlKHBkZXYsIHJlZ3ZhbCwgYnZhbCk7
DQotCQl9IGVsc2Ugew0KKwkJCXBjaV93cml0ZV9jb25maWdfYnl0ZShwZGV2
LCAweDgwLCBidmFsKTsNCisJCX0gZWxzZQ0KIAkJCWJ2YWwgPSAwOw0KLQkJ
CXJlZ3ZhbCA9IDB4YzA7DQotCQl9DQogDQogCQl1ZGVsYXkoMTYwKTsNCi0J
CXBjaV93cml0ZV9jb25maWdfYnl0ZShwZGV2LCByZWd2YWwsIGJ2YWwgfCAw
eDgwKTsNCisJCXBjaV93cml0ZV9jb25maWdfYnl0ZShwZGV2LCAweDgwLCBi
dmFsIHwgMHg4MCk7DQogCQl1ZGVsYXkoMTYwKTsNCi0JCXBjaV93cml0ZV9j
b25maWdfYnl0ZShwZGV2LCByZWd2YWwsIDApOw0KKwkJcGNpX3dyaXRlX2Nv
bmZpZ19ieXRlKHBkZXYsIDB4ODAsIDApOw0KIAkJdWRlbGF5KDE2MCk7DQog
DQogCQljYXJyeUZsYWcgPSAoY21kICYgaikgPyAxIDogMDsNCg==

---1463811839-1537914030-1095712523=:6785--
