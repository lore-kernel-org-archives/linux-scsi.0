From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 19:12:11 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404131911110.4021-200000@poirot.grange>
References: <200404131614.31583.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-649030011-1081876331=:4021"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:23680 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263613AbUDMRMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 13:12:50 -0400
In-Reply-To: <200404131614.31583.info@roessner-net.com>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-649030011-1081876331=:4021
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 13 Apr 2004, Christian Roessner wrote:

> /var/log/kernel/current_debug attached.

Great! Please, try the next one (on the top of the current).

Guennadi
---
Guennadi Liakhovetski


---1463811839-649030011-1081876331=:4021
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-dma_len.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0404131912111.4021@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-dma_len.patch"

LS0tIGxpbnV4LTIuNi4zLmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2lt
LmN+CU1vbiBBcHIgMTIgMTM6MDA6MDggMjAwNA0KKysrIGxpbnV4LTIuNi4z
LmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJVHVlIEFwciAxMyAx
OToxMDozOCAyMDA0DQpAQCAtMTAyNCw3ICsxMDI0LDcgQEANCiAJCQlwY2lf
bWFwX3BhZ2UocGRldiwgdmlydF90b19wYWdlKHBjbWQtPnNlbnNlX2J1ZmZl
ciksDQogCQkJCSAgICAgKHVuc2lnbmVkIGxvbmcpcGNtZC0+c2Vuc2VfYnVm
ZmVyICYgflBBR0VfTUFTSywgc2l6ZW9mKHBjbWQtPnNlbnNlX2J1ZmZlciks
DQogCQkJCSAgICAgRE1BX0ZST01fREVWSUNFKTsNCi0JCXBTUkItPlNlZ21l
bnR4Lmxlbmd0aCA9IHNpemVvZihwY21kLT5zZW5zZV9idWZmZXIpOw0KKwkJ
c2dfZG1hX2xlbigmcFNSQi0+U2VnbWVudHgpID0gc2l6ZW9mKHBjbWQtPnNl
bnNlX2J1ZmZlcik7DQogCQlwU1JCLT5TR2NvdW50ID0gMTsNCiAJCXBTUkIt
PnBTZWdtZW50TGlzdCA9IChQU0dMKSAmcFNSQi0+U2VnbWVudHg7DQogCQlE
RUJVRzEocHJpbnRrKCIlcygpOiBNYXBwZWQgc2Vuc2UgYnVmZmVyICVwIGF0
ICV4XG4iLCBfX0ZVTkNUSU9OX18sIHBjbWQtPnNlbnNlX2J1ZmZlciwgY21k
cC0+c2F2ZWRfZG1hX2hhbmRsZSkpOw0KQEAgLTEwNDUsNyArMTA0NSw3IEBA
DQogCQkJCSAgICAgKHVuc2lnbmVkIGxvbmcpcGNtZC0+cmVxdWVzdF9idWZm
ZXIgJiB+UEFHRV9NQVNLLA0KIAkJCQkgICAgIHBjbWQtPnJlcXVlc3RfYnVm
Zmxlbiwgc2NzaV90b19wY2lfZG1hX2RpcihwY21kLT5zY19kYXRhX2RpcmVj
dGlvbikpOw0KIAkJLyogVE9ETzogZXJyb3IgaGFuZGxpbmcgKi8NCi0JCXBT
UkItPlNlZ21lbnR4Lmxlbmd0aCA9IHBjbWQtPnJlcXVlc3RfYnVmZmxlbjsN
CisJCXNnX2RtYV9sZW4oJnBTUkItPlNlZ21lbnR4KSA9IHNpemVvZihwY21k
LT5zZW5zZV9idWZmZXIpOw0KIAkJcFNSQi0+U0djb3VudCA9IDE7DQogCQlw
U1JCLT5wU2VnbWVudExpc3QgPSAoUFNHTCkgJnBTUkItPlNlZ21lbnR4Ow0K
IAkJREVCVUcxKHByaW50aygiJXMoKTogTWFwcGVkIHJlcXVlc3QgYnVmZmVy
ICVwIGF0ICV4XG4iLCBfX0ZVTkNUSU9OX18sIHBjbWQtPnJlcXVlc3RfYnVm
ZmVyLCBjbWRwLT5zYXZlZF9kbWFfaGFuZGxlKSk7DQo=
---1463811839-649030011-1081876331=:4021--
