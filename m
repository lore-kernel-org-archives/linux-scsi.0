From: Peter Chang <dpf@google.com>
Subject: [patch] check length passed to SG_NEXT_CMD_LEN
Date: Thu, 2 Mar 2017 10:29:39 -0800
Message-ID: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11408cd2ecbb410549c39dfa
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35266 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdCCQVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 11:21:13 -0500
Received: by mail-oi0-f51.google.com with SMTP id 62so58133556oih.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 08:20:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>

--001a11408cd2ecbb410549c39dfa
Content-Type: text/plain; charset=UTF-8

now that i think i've got gmail not marking everything as spam...

\p

--001a11408cd2ecbb410549c39dfa
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-sg-check-length-passed-to-SG_NEXT_CMD_LEN.patch"
Content-Disposition: attachment;
	filename="0001-sg-check-length-passed-to-SG_NEXT_CMD_LEN.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_izsq6rbp0

RnJvbSA5MzQwOWM2MmRiNDlkMTUxMDUzOTAzMTVhNjg1ZTU0MDgzMDI5YmVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBwZXRlciBjaGFuZyA8ZHBmQGdvb2dsZS5jb20+CkRhdGU6IFdl
ZCwgMTUgRmViIDIwMTcgMTQ6MTE6NTQgLTA4MDAKU3ViamVjdDogW1BBVENIXSBbc2ddIGNoZWNr
IGxlbmd0aCBwYXNzZWQgdG8gU0dfTkVYVF9DTURfTEVOCgp0aGUgdXNlciBjYW4gY29udHJvbCB0
aGUgc2l6ZSBvZiB0aGUgbmV4dCBjb21tYW5kIHBhc3NlZCBhbG9uZywgYnV0CnRoZSB2YWx1ZSBw
YXNzZWQgdG8gdGhlIGlvY3RsIGlzbid0IGNoZWNrZWQgYWdhaW5zdCB0aGUgdXNhYmxlCm1heCBj
b21tYW5kIHNpemUuCgpDaGFuZ2UtSWQ6IEk5YWMyYWUwN2MzNWNmNWZkYTYyZDdhZmFkMzJjOGQ5
YWI2YTllYTFkClRlc3RlZDogc2FuaXR5IGNoZWNrZWQgdy8gY2FsbGluZyB0aGUgaW9jdGwgdy8g
YSBib2d1cyBzaXplCi0tLQogZHJpdmVycy9zY3NpL3NnLmMgfCAyICsrCiAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NnLmMgYi9kcml2
ZXJzL3Njc2kvc2cuYwppbmRleCA5YzVjNWYyYjM5NjIuLmI0N2EzNjljYjcxYyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zY3NpL3NnLmMKKysrIGIvZHJpdmVycy9zY3NpL3NnLmMKQEAgLTk3Niw2ICs5
NzYsOCBAQCBzZ19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWduZWQgaW50IGNtZF9pbiwg
dW5zaWduZWQgbG9uZyBhcmcpCiAJCXJlc3VsdCA9IGdldF91c2VyKHZhbCwgaXApOwogCQlpZiAo
cmVzdWx0KQogCQkJcmV0dXJuIHJlc3VsdDsKKwkJaWYgKHZhbCA+IFNHX01BWF9DREJfU0laRSkK
KwkJCXJldHVybiAtRU5PTUVNOwogCQlzZnAtPm5leHRfY21kX2xlbiA9ICh2YWwgPiAwKSA/IHZh
bCA6IDA7CiAJCXJldHVybiAwOwogCWNhc2UgU0dfR0VUX1ZFUlNJT05fTlVNOgotLSAKMi4xMi4w
LnJjMS40NDAuZzViNzY1NjVmNzQtZ29vZwoK
--001a11408cd2ecbb410549c39dfa--
