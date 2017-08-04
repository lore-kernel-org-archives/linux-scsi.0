From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/2] generate uevent for SCSI sense code
Date: Fri, 4 Aug 2017 17:18:49 +0000
Message-ID: <98B7207C-AF0B-4157-A417-68387E634FE2@fb.com>
References: <20170721225732.311745-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51085 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752132AbdHDRTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 13:19:04 -0400
In-Reply-To: <20170721225732.311745-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <188B071F9ACFE841A2D3DFE0F16BFC32@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "emilne@redhat.com" <emilne@redhat.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

SGkgYWxsLCANCg0KQ291bGQgeW91IHBsZWFzZSBzaGFyZSB5b3VyIGZlZWRiYWNrIG9uIHRoaXMg
dmVyc2lvbiBvZiB0aGUgY2hhbmdlPyANCiANClRoYW5rcyBpbiBhZHZhbmNlLA0KU29uZw0KDQo+
PiBPbiA3LzIxLzE3LCAzOjU4IFBNLCAiU29uZyBMaXUiIDxzb25nbGl1YnJhdmluZ0BmYi5jb20+
IHdyb3RlOg0KDQogICAgVGhpcyBjaGFuZ2UgaXMgdG8gZm9sbG93IHVwIG91ciBkaXNjdXNzaW9u
IG9uIGV2ZW50IGxvZyBmb3IgbWVkaWENCiAgICBtYW5hZ2VtZW50IGR1cmluZyBMU0YvTU0gMjAx
Ny4NCiAgICANCiAgICBDaGFuZ2VzIGZyb20gUkZDIHYzOg0KICAgICAgSW5jb3Jwb3JhdGUgZmVl
ZGJhY2sgYnkgSm9oYW5uZXMgVGh1bXNoaXJuDQogICAgDQogICAgVGhhbmtzLA0KICAgIFNvbmcN
CiAgICANCiAgICBTb25nIExpdSAoMik6DQogICAgICBzY3NpOiBnZW5lcmF0ZSB1ZXZlbnQgZm9y
IFNDU0kgc2Vuc2UgY29kZQ0KICAgICAgc2NzaTogYWRkIHJhdGUgbGltaXQgdG8gc2NzaSBzZW5z
ZSBjb2RlIHVldmVudA0KICAgIA0KICAgICBkcml2ZXJzL3Njc2kvS2NvbmZpZyAgICAgICB8IDE0
ICsrKysrKysrKysrDQogICAgIGRyaXZlcnMvc2NzaS9ob3N0cy5jICAgICAgIHwgIDQgKysrKw0K
ICAgICBkcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jICB8IDU4ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCiAgICAgZHJpdmVycy9zY3NpL3Njc2lfbGliLmMg
ICAgfCA1OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQog
ICAgIGRyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMgIHwgNTEgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KICAgICBpbmNsdWRlL3Njc2kvc2NzaV9jb21tb24uaCB8ICA2
ICsrKysrDQogICAgIGluY2x1ZGUvc2NzaS9zY3NpX2RldmljZS5oIHwgMjcgKysrKysrKysrKysr
KysrKysrKystDQogICAgIGluY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaCAgIHwgMTMgKysrKysrKysr
KysNCiAgICAgOCBmaWxlcyBjaGFuZ2VkLCAyMjkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCiAgICANCiAgICAtLQ0KICAgIDIuOS4zDQogICAgDQoNCg==
