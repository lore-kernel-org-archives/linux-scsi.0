From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:for-next 12/27] drivers/scsi/ipr.c:6568 ipr_qc_issue()
 warn: inconsistent returns spin_lock:&ipr_cmd->hrrq->_lock: locked (6562)
 unlocked (6499,6507,6568)
Date: Thu, 20 Dec 2012 22:52:16 +0000
Message-ID: <1356043933.8606.39.camel@dabdike.home>
References: <20121217132403.GO5083@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:35280 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2LTWwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2012 17:52:19 -0500
In-Reply-To: <20121217132403.GO5083@mwanda>
Content-Language: en-US
Content-ID: <CAB1113A455ACE418F0BD0CE9B233967@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kbuild@01.org" <kbuild@01.org>, Hiral Patel <hiralpat@cisco.com>

T24gTW9uLCAyMDEyLTEyLTE3IGF0IDE2OjI0ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBIaSwNCj4gDQo+IEZZSSwgdGhlcmUgYXJlIG5ldyBzbWF0Y2ggd2FybmluZ3Mgc2hvdyB1cCBp
bg0KPiANCj4gdHJlZTogICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvamVqYi9zY3NpLmdpdCBmb3ItbmV4dA0KPiBoZWFkOiAgIGUzZmYxOTdhNzUwZDI5MTJk
MGJiMmEwMTYxYzIzYzE4YmFkMjUwYWQNCj4gY29tbWl0OiBlN2VmNzMwN2Q5ZTJjMTU4MDJlOGVh
MWRhOTg3OGUwNTUwZWM4N2JjIFsxMi8yN10gW1NDU0ldIGlwcjogUmVkdWNlIGxvY2sgY29udGVu
dGlvbg0KPiANCj4gICBkcml2ZXJzL3Njc2kvaXByLmM6NTQzNCBpcHJfYnVpbGRfaW9hZGw2NCgp
IGluZm86IHdoeSBub3QgcHJvcGFnYXRlICduc2VnJyBmcm9tIHNjc2lfZG1hX21hcCgpIGluc3Rl
YWQgb2YgKC0xKT8NCj4gICBkcml2ZXJzL3Njc2kvaXByLmM6NTQ4NSBpcHJfYnVpbGRfaW9hZGwo
KSBpbmZvOiB3aHkgbm90IHByb3BhZ2F0ZSAnbnNlZycgZnJvbSBzY3NpX2RtYV9tYXAoKSBpbnN0
ZWFkIG9mICgtMSk/DQo+ICsgZHJpdmVycy9zY3NpL2lwci5jOjY1NjggaXByX3FjX2lzc3VlKCkg
d2FybjogaW5jb25zaXN0ZW50IHJldHVybnMgc3Bpbl9sb2NrOiZpcHJfY21kLT5ocnJxLT5fbG9j
azogbG9ja2VkICg2NTYyKSB1bmxvY2tlZCAoNjQ5OSw2NTA3LDY1NjgpDQoNCkxvb2ssIGd1eXMs
IEkndmUgZ290IHRoZXNlIHR5cGUgb2YgcmVwb3J0cyBvbiBhYm91dCA1MCUgb2YgdGhlIHBhdGNo
ZXMNCmluIHRoZSBtaXNjIGJyYW5jaCBvZiB0aGUgU0NTSSB0cmVlLiAgVGhpcyBlZmZlY3RpdmVs
eSBtZWFucyBJIGRvbid0DQpoYXZlIGEgdHJlZSBkbyBkbyBhIGZpbmFsIHB1bGwgcmVxdWVzdCBv
biAuLi4gdW5sZXNzIHlvdSdkIGxpa2UgdG8gZ2V0DQpvZmYgeW91ciBhcnNlcyBhbmQgYWN0dWFs
bHkgc2VuZCBpbiBzb21lIGZpeGVzLg0KDQpKYW1lcw0KDQo=
