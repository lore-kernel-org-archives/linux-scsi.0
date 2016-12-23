From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 02/10] qla2xxx: Include ATIO queue in firmware dump
 when in target mode
Date: Fri, 23 Dec 2016 08:32:31 +0000
Message-ID: <1482481930.3510.2.camel@sandisk.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
         <1482357459-31079-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0068.outbound.protection.outlook.com ([104.47.34.68]:56406
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750701AbcLWIcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Dec 2016 03:32:41 -0500
In-Reply-To: <1482357459-31079-3-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <5313EA78616F5A488D7A0C2C093CBC2A@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

T24gV2VkLCAyMDE2LTEyLTIxIGF0IDEzOjU3IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBAQCAtNjc2LDYgKzY4OCwxOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgKCpxbGEyN3h4X3Jl
YWRfdmVjdG9yKHVpbnQgd2lkdGgpKSh2b2lkIF9faW9tZW0qLCB2b2lkICosIHVsbw0KPiAgCQkJ
CWNvdW50Kys7DQo+ICAJCQl9DQo+ICAJCX0NCj4gKwl9IGVsc2UgaWYgKFFMQV9UR1RfTU9ERV9F
TkFCTEVEKCkgJiYNCj4gKwkgICAgZW50LT50Mjc0LnF1ZXVlX3R5cGUgPT0gVDI3NF9RVUVVRV9U
WVBFX0FUSU9fU0hBRCkgew0KPiArCQlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhhID0gdmhhLT5odzsN
Cj4gKwkJc3RydWN0IGF0aW8gKmF0ciA9IGhhLT50Z3QuYXRpb19yaW5nX3B0cjsNCj4gKw0KPiAr
CQlpZiAoYXRyIHx8ICFidWYpIHsNCj4gKwkJCXFsYTI3eHhfaW5zZXJ0MTYoMCwgYnVmLCBsZW4p
Ow0KPiArCQkJcWxhMjd4eF9pbnNlcnQxNigxLCBidWYsIGxlbik7DQo+ICsJCQlxbGEyN3h4X2lu
c2VydDMyKGhhLT50Z3QuYXRpb19xX2luID8NCj4gKwkJCSAgICAqaGEtPnRndC5hdGlvX3FfaW4g
OiAwLCBidWYsIGxlbik7DQo+ICsJCQljb3VudCsrOw0KPiArCQl9DQo+ICAJfSBlbHNlIHsNCj4g
IAkJcWxfZGJnKHFsX2RiZ19taXNjLCB2aGEsIDB4ZDAyZiwNCj4gIAkJICAgICIlczogdW5rbm93
biBxdWV1ZSAleFxuIiwgX19mdW5jX18sIGVudC0+dDI3NC5xdWV1ZV90eXBlKTsNCg0KSGVsbG8g
SGltYW5zaHUsDQoNClRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIG5ldyBzcGFyc2Ugd2FybmluZyBm
b3LCoCpoYS0+dGd0LmF0aW9fcV9pbjoNCg0KZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RtcGwu
Yzo3MDA6Mzc6IHdhcm5pbmc6IGRlcmVmZXJlbmNlIG9mIG5vZGVyZWYgZXhwcmVzc2lvbg0KDQpT
cGFyc2UgcmVwb3J0cyB0aGlzIGJlY2F1c2UgdGhlIGF0aW9fcV9pbiBwb2ludGVyIGlzIGRlY2xh
cmVkIGFzIHVpbnQzMl90IF9faW9tZW0qLg0KRG9lcyB0aGlzIHBlcmhhcHMgbWVhbiB0aGF0IGEg
cmVhZGwoKSBjYWxsIGlzIG1pc3Npbmc/DQoNCkJhcnQu
