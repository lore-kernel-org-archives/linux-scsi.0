From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH]sd: Don't treat succeeded SYNC as error
Date: Mon, 25 Apr 2016 12:36:12 +0200
Message-ID: <CAMGffEnAYXdYNfN7aHZHLjnhxY2T2V6m4tPNi4eT4kDuarrYxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113ce046fd664305314cbff3
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34975 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbcDYKgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 06:36:32 -0400
Received: by mail-oi0-f53.google.com with SMTP id x19so38100605oix.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2016 03:36:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>
Cc: s.parschauer@gmx.de

--001a113ce046fd664305314cbff3
Content-Type: text/plain; charset=UTF-8

Hi, all

We hit IO error on fsync, it turns out was because sd treat succeeded
SYNC as error. From what I checked in SBC spec there is no indication
we should fail IO in this case, so we create this patch.


Best Regards,

Jack Wang

--001a113ce046fd664305314cbff3
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-sd-Don-t-treat-succeeded-SYNC-as-error.patch"
Content-Disposition: attachment;
	filename="0001-sd-Don-t-treat-succeeded-SYNC-as-error.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_infv3l1x0

RnJvbSA1ZDFmNzJkOTY0M2NlNjFjZDlmM2QzMTIzNzczNzhjNDNmMTcxZDBjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAyNSBBcHIgMjAxNiAxMjowNToyMiArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHNkOiBEb24ndCB0cmVhdCBzdWNjZWVkZWQgU1lOQyBhcyBlcnJvcgoKV2UgaGl0IElPIGVycm9y
IGluIG91ciBwcm9kdWN0aW9uIG9uIG11bHRpcGF0aCBkZXZpY2VzIGR1cmluZyByZXNpemUKZGV2
aWNlIG9uIHRhcmdldCBzaWRlLCB0aGUgcHJvYmxlbSB0dXJucyBvdXQgc2QgZHJpdmVyIHBhc3Nl
cyB1cCBhcyBJTwplcnJvciB3aGVuIHNlbnNlIGRhdGEgaXMgVU5JVF9BVFRFTlRJT04gYW5kIEFT
QyAmJiBBU0NRIGluZGljYXRlCkNhcGFjaXR5IGRhdGEgaGFzIGNoYW5nZWQsIGV2ZW4gc3RvcmFn
ZSBzaWRlIHN5bmMgdGhlIGRhdGEgcHJvcGVybHkuCgpJbiBvcmRlciB0byBmaXggdGhpcyBjaGVj
ayBpbiBzZF9kb25lLCByZXBvcnQgc3VjY2VzcyBpZiBjb25kaXRpb24KbWF0Y2hlcy4KClNlYmFz
dGlhbiBQYXJzY2hhdWVyIHJlcG9ydC9hbmFseXplIHRoZSBidWcgaGVyZToKaHR0cHM6Ly9zb3Vy
Y2Vmb3JnZS5uZXQvcC9zY3N0L21haWxtYW4vbWVzc2FnZS8zNDk1MzQxNi8KClNpZ25lZC1vZmYt
Ynk6IFNlYmFzdGlhbiBQYXJzY2hhdWVyIDxzLnBhcnNjaGF1ZXJAZ214LmRlPgpTaWduZWQtb2Zm
LWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJz
L3Njc2kvc2QuYyB8IDEzICsrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkLmMgYi9kcml2ZXJzL3Njc2kvc2Qu
YwppbmRleCA1YTU0NTdhLi5lOWJmZTAxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2QuYwor
KysgYi9kcml2ZXJzL3Njc2kvc2QuYwpAQCAtMTgzMyw2ICsxODMzLDE5IEBAIHN0YXRpYyBpbnQg
c2RfZG9uZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCkKIAkJCX0KIAkJfQogCQlicmVhazsKKwlj
YXNlIFVOSVRfQVRURU5USU9OOgorCQkvKiBDYXBhY2l0eSBkYXRhIGhhcyBjaGFuZ2VkICovCisJ
CWlmIChzc2hkci5hc2MgPT0gMHgyYSAmJiBzc2hkci5hc2NxID09IDB4MDkpIHsKKwkJCXN3aXRj
aCAob3ApIHsKKwkJCS8qIGRvbid0IHRyZWF0IHN1Y2NlZWRlZCBmc3luYygpIGFzIGVycm9yICov
CisJCQljYXNlIFNZTkNIUk9OSVpFX0NBQ0hFOgorCQkJY2FzZSBTWU5DSFJPTklaRV9DQUNIRV8x
NjoKKwkJCQlpZiAoZ29vZF9ieXRlcyA9PSBzY3NpX2J1ZmZsZW4oU0NwbnQpKQorCQkJCQlTQ3Bu
dC0+cmVzdWx0ID0gMDsKKwkJCQkJYnJlYWs7CisJCQl9CisJCX0KKwkJYnJlYWs7CiAJZGVmYXVs
dDoKIAkJYnJlYWs7CiAJfQotLSAKMS45LjEKCg==
--001a113ce046fd664305314cbff3--
