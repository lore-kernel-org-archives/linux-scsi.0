From: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>
Subject: RE: [PATCH] [SCSI] bnx2fc: move the dereference below the NULL test
Date: Fri, 7 Sep 2012 08:46:39 +0000
Message-ID: <A360F954C61C69449463B060666371121CDCB08E@CDCEXMBX01.tw.trendnet.org>
References: <CAPgLHd-N6Sx-d2_28+FFkWaXCB0gQQJBBZWouPwzFeOm6wkRxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sjdciscan01.udc.trendmicro.com ([66.180.82.17]:53751 "EHLO
	sjdciscan01.udc.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757914Ab2IGJQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2012 05:16:10 -0400
In-Reply-To: <CAPgLHd-N6Sx-d2_28+FFkWaXCB0gQQJBBZWouPwzFeOm6wkRxQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bprakash@broadcom.com" <bprakash@broadcom.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

U29ycnksIEkgc2VlIHRoZSBwYXRjaCBmaXggdGhpcyBpc3N1ZSBoYXMgYWxyZWFkeSBleGlzdHMg
aW4gdGhlIG1haWxsaXN0LA0KcGxlYXNlIGlnbm9yZSBpdCwgdGhhbmtzLg0KDQotLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogV2VpIFlvbmdqdW4gW21haWx0bzp3ZWl5ai5sa0BnbWFp
bC5jb21dIA0KU2VudDogMjAxMsTqOdTCN8jVIDE1OjAwDQpUbzogYnByYWthc2hAYnJvYWRjb20u
Y29tOyBKQm90dG9tbGV5QHBhcmFsbGVscy5jb20NCkNjOiBZb25nanVuIFdlaSAoUkQtQ04pOyBs
aW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogW1BBVENIXSBbU0NTSV0gYm54MmZj
OiBtb3ZlIHRoZSBkZXJlZmVyZW5jZSBiZWxvdyB0aGUgTlVMTCB0ZXN0DQoNCkZyb206IFdlaSBZ
b25nanVuIDx5b25nanVuX3dlaUB0cmVuZG1pY3JvLmNvbS5jbj4NCg0KVGhlIGRlcmVmZXJlbmNl
IHNob3VsZCBiZSBtb3ZlZCBiZWxvdyB0aGUgTlVMTCB0ZXN0Lg0KDQoNCg0KVFJFTkQgTUlDUk8g
RU1BSUwgTk9USUNFDQpUaGUgaW5mb3JtYXRpb24gY29udGFpbmVkIGluIHRoaXMgZW1haWwgYW5k
IGFueSBhdHRhY2htZW50cyBpcyBjb25maWRlbnRpYWwgYW5kIG1heSBiZSBzdWJqZWN0IHRvIGNv
cHlyaWdodCBvciBvdGhlciBpbnRlbGxlY3R1YWwgcHJvcGVydHkgcHJvdGVjdGlvbi4gSWYgeW91
IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgeW91IGFyZSBub3QgYXV0aG9yaXplZCB0
byB1c2Ugb3IgZGlzY2xvc2UgdGhpcyBpbmZvcm1hdGlvbiwgYW5kIHdlIHJlcXVlc3QgdGhhdCB5
b3Ugbm90aWZ5IHVzIGJ5IHJlcGx5IG1haWwgb3IgdGVsZXBob25lIGFuZCBkZWxldGUgdGhlIG9y
aWdpbmFsIG1lc3NhZ2UgZnJvbSB5b3VyIG1haWwgc3lzdGVtLg==

