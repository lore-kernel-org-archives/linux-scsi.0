From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Mon, 6 Mar 2017 00:43:08 +0000
Message-ID: <1488760974.2808.1.camel@sandisk.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43474 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbdCFBUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2017 20:20:15 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <B293291301612641B922F218E77A257B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

T24gRnJpLCAyMDE3LTAyLTI0IGF0IDEzOjM3IC0wODAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3Rl
Og0KPiBQbGVhc2UgY29uc2lkZXIgdGhpcyBzZXJpZXMgZm9yIGluY2x1c2lvbiBpbiB0YXJnZXQt
cGVuZGluZy4NCg0KSGVsbG8gSGltYW5zaHUsDQoNCkkgYXBwbGllZCB0aGlzIHBhdGNoIHNlcmll
cyBvbiB0b3Agb2Yga2VybmVsIHY0LjExLXJjMSBhbmQgaW5zdGFsbGVkIGl0IG9uDQphIHRlc3Qg
c3lzdGVtLiBVbmZvcnR1bmF0ZWx5IHRoZSByZWdyZXNzaW9uIEkgcmVwb3J0ZWQgb25lIG1vbnRo
IGFnbyBhZ2FpbnN0DQp2MiBvZiB0aGlzIHBhdGNoIHNlcmllcyBzdGlsbCBvY2N1cnMgd2l0aCB2
MyBvZiB0aGlzIHBhdGNoIHNlcmllczoNCg0KSU5GTzogdGFzayBrd29ya2VyLzI6MTo3MSBibG9j
a2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29uZHMuDQogICAgICBOb3QgdGFpbnRlZCA0LjExLjAt
cmMxLWRiZysgIzENCiJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0
X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4NCmt3b3JrZXIvMjoxICAgICBEICAgIDAgICAg
NzEgICAgICAyIDB4MDAwMDAwMDANCldvcmtxdWV1ZTogZXZlbnRzIHFsdF9mcmVlX3Nlc3Npb25f
ZG9uZSBbcWxhMnh4eF0NCkNhbGwgVHJhY2U6DQogX19zY2hlZHVsZSsweDFlZi8weGE3MA0KIHNj
aGVkdWxlKzB4NDAvMHg5MA0KIHNjaGVkdWxlX3RpbWVvdXQrMHgyNTgvMHg0YTANCiB3YWl0X2Zv
cl9jb21wbGV0aW9uKzB4MTA4LzB4MTcwDQogdGFyZ2V0X3dhaXRfZm9yX3Nlc3NfY21kcysweDU2
LzB4MWIwIFt0YXJnZXRfY29yZV9tb2RdDQogdGNtX3FsYTJ4eHhfZnJlZV9zZXNzaW9uKzB4NDUv
MHg5MCBbdGNtX3FsYTJ4eHhdDQogcWx0X2ZyZWVfc2Vzc2lvbl9kb25lKzB4NDRhLzB4NTUwIFtx
bGEyeHh4XQ0KIHByb2Nlc3Nfb25lX3dvcmsrMHgyMGQvMHg2YzANCiB3b3JrZXJfdGhyZWFkKzB4
NGUvMHg0YTANCiBrdGhyZWFkKzB4MTBjLzB4MTQwDQogcmV0X2Zyb21fZm9yaysweDMxLzB4NDAN
Cg0KQmFydC4=
