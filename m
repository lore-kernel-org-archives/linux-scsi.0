From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Sat, 10 Apr 2004 23:42:49 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404102328170.8662-200000@poirot.grange>
References: <200404102239.22192.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-19480411-1081633369=:8662"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:14298 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262119AbUDJVnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2004 17:43:50 -0400
In-Reply-To: <200404102239.22192.info@roessner-net.com>
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-19480411-1081633369=:8662
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sat, 10 Apr 2004, Christian Roessner wrote:

> DC390_init: No EEPROM found! Trying default settings ...
> DC390: Used defaults: AdaptID=7, SpeedIdx=1 (8.0 MHz), DevMode=0x1f,
> AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
> DC390: 1 adapters found
> scsi1 : Tekram DC390/AM53C974 V2.0f 2000-12-20
...
> DC390: DMA Blast aborted unfinished!
>   Vendor:           Model:                   Rev:
>   Type:   Direct-Access                      ANSI SCSI revision: 00
> Attached scsi generic sg1 at scsi1, channel 0, id 4, lun 0,  type 0
> DC390: DMA Blast aborted unfinished!
...

Yes, indeed, there's a DMA-ing problem. Could you, please, try the
attached patch, although, I am not sure it'll help...

Thanks
Guennadi
---
Guennadi Liakhovetski


---1463811839-19480411-1081633369=:8662
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmscsim-set_dma_mask.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0404102342490.8662@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="tmscsim-set_dma_mask.patch"

LS0tIGxpbnV4LTIuNi4zLmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2lt
LmN+CUZyaSBNYXIgMTIgMjI6MjI6MTEgMjAwNA0KKysrIGxpbnV4LTIuNi4z
LmhhcmRsaW5rL2RyaXZlcnMvc2NzaS90bXNjc2ltLmMJU2F0IEFwciAxMCAy
MzowODoxNSAyMDA0DQpAQCAtMjIzNiwxMCArMjIzNiwxMyBAQA0KICAgICBp
ZiAoIFBDSV9QUkVTRU5UICkNCiAJd2hpbGUgKFBDSV9GSU5EX0RFVklDRSAo
UENJX1ZFTkRPUl9JRF9BTUQsIFBDSV9ERVZJQ0VfSURfQU1ENTNDOTc0KSkN
CiAJew0KLSNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPiBLRVJORUxfVkVSU0lP
TigyLDMsMzApDQogCSAgICBpZiAocGNpX2VuYWJsZV9kZXZpY2UgKHBkZXYp
KQ0KIAkJY29udGludWU7DQotI2VuZGlmDQorDQorCSAgICBpZiAocGNpX3Nl
dF9kbWFfbWFzayhwZGV2LCAweGZmZmZmZmZmKSkgew0KKwkJICAgIHByaW50
ayhLRVJOX0VSUiAiREMzOTAoJWkpOiBObyBzdWl0YWJsZSBETUEgYXZhaWxh
YmxlLlxuIiwgZGMzOTBfYWRhcHRlckNudCk7DQorCQkgICAgY29udGludWU7
DQorCSAgICB9DQogCSAgICBQQ0lfR0VUX0lPX0FORF9JUlE7DQogCSAgICBE
RUJVRzAocHJpbnRrKEtFUk5fSU5GTyAiREMzOTAoJWkpOiBJT19QT1JUPSUw
NHgsSVJRPSV4XG4iLCBkYzM5MF9hZGFwdGVyQ250LCAoVUlOVCkgaW9fcG9y
dCwgaXJxKSk7DQogDQo=
---1463811839-19480411-1081633369=:8662--
