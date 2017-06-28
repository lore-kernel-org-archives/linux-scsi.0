From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2] qla2xxx: Protect access to qpair members with
 qpair->qp_lock
Date: Wed, 28 Jun 2017 01:44:31 +0000
Message-ID: <E582614F-2B53-44BF-8E2E-000E27D510AB@cavium.com>
References: <20170623071011.21184-1-jthumshirn@suse.de>
 <yq1bmp8zylp.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0052.outbound.protection.outlook.com ([104.47.41.52]:4960
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752694AbdF1Boe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 21:44:34 -0400
In-Reply-To: <yq1bmp8zylp.fsf@oracle.com>
Content-Language: en-US
Content-ID: <411C0DB3FF271B4085E344B736582C05@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>

SGkgTWFydGluLA0KDQpPbiA2LzI3LzE3LCA2OjMyIFBNLCAiTWFydGluIEsuIFBldGVyc2VuIiA8
bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+IHdyb3RlOg0KDQogICAgDQogICAgPiBJbiBxbGEy
eHhfc3RhcnRfc2NzaV9tcSgpIGFuZCBxbGEyeHhfZGlmX3N0YXJ0X3Njc2lfbXEoKSB3ZSBncmFi
IHRoZQ0KICAgID4gcXBhaXItPnFwX2xvY2sgYnV0IGRvIGFjY2VzcyBtZW1iZXJzIG9mIHRoZSBx
cGFpciBiZWZvcmUgaGF2aW5nIHRoZSBsb2NrLg0KICAgID4gUmUtb3JkZXIgdGhlIGxvY2tpbmcg
c2VxdWVuY2UgdG8gaGF2ZSBhbGwgcmVhZCBhbmQgd3JpdGUgYWNjZXNzIHRvIHFwYWlyDQogICAg
PiBtZW1iZXJzIHVuZGVyIHRoZSBxcGFpci0+cXBfbG9jay4NCiAgICANCiAgICBDYXZpdW0gZm9s
a3MsIHBsZWFzZSByZXZpZXchDQoNCkkgYW0gdGVzdGluZyBpdCBpbnRlcm5hbGx5LCB3aWxsIHVw
ZGF0ZSBieSB0b21vcnJvdy4gDQogICAgDQogICAgLS0gDQogICAgTWFydGluIEsuIFBldGVyc2Vu
CU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0KICAgIA0KVGhhbmtzLA0KSGltYW5zaHUNCg0KDQo=
