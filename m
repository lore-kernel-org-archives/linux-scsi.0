From: Thibaut VARENE <varenet@parisc-linux.org>
Subject: [PATCH] linux-2.5.46: Remove unused variable
Date: Sat, 9 Nov 2002 23:44:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021109234452.68056ede.varenet@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Sat__9_Nov_2002_23:44:52_+0100_10245df8"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: willy@debian.org

This is a multi-part message in MIME format.

--Multipart_Sat__9_Nov_2002_23:44:52_+0100_10245df8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

While cleaning up some parisc files, I took a look at some arch-indep ones.

This fixes a compiler warning.

HTH,

Thibaut VARENE
The PA/Linux ESIEE Team
http://pateam.esiee.fr/

--Multipart_Sat__9_Nov_2002_23:44:52_+0100_10245df8
Content-Type: text/plain;
 name="sd.c.diff"
Content-Disposition: attachment;
 filename="sd.c.diff"
Content-Transfer-Encoding: base64

LS0tIC93b3JrL3BhL0NWUy1taXJyb3IvbGludXgtMi41L2RyaXZlcnMvc2NzaS9zZC5jCTIwMDIt
MTEtMDYgMTI6MTc6MzcuMDAwMDAwMDAwICswMTAwCisrKyBkcml2ZXJzL3Njc2kvc2QuYwkyMDAy
LTExLTA5IDE3OjU4OjUxLjAwMDAwMDAwMCArMDEwMApAQCAtNzU4LDcgKzc1OCw2IEBACiBzZF9z
cGludXBfZGlzayhzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwLCBjaGFyICpkaXNrbmFtZSwKIAkgICAg
ICAgc3RydWN0IHNjc2lfcmVxdWVzdCAqU1JwbnQsIHVuc2lnbmVkIGNoYXIgKmJ1ZmZlcikgewog
CXVuc2lnbmVkIGNoYXIgY21kWzEwXTsKLQlzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkcCA9IHNka3At
PmRldmljZTsKIAl1bnNpZ25lZCBsb25nIHNwaW50aW1lX3ZhbHVlID0gMDsKIAlpbnQgdGhlX3Jl
c3VsdCwgcmV0cmllcywgc3BpbnRpbWU7CiAK

--Multipart_Sat__9_Nov_2002_23:44:52_+0100_10245df8--
