From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [patch] check length passed to SG_NEXT_CMD_LEN
Date: Fri, 3 Mar 2017 08:17:16 +0100
Message-ID: <CACT4Y+Z7TpEMwWFLQsfntpVacrq9EsscGLoKQNUp5dBehNN=hQ@mail.gmail.com>
References: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f403045f077418fba90549ce57e8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:36843 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdCCJCY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 04:02:24 -0500
Received: by mail-ua0-f172.google.com with SMTP id 72so107581161uaf.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 01:02:23 -0800 (PST)
In-Reply-To: <CAF2xp_GW8KwyD9AuZjHFoPtiNdRyPQ27+1jDLEJjuKxci3mU6w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Chang <dpf@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>

--f403045f077418fba90549ce57e8
Content-Type: text/plain; charset=UTF-8

On Thu, Mar 2, 2017 at 7:29 PM, Peter Chang <dpf@google.com> wrote:
> now that i think i've got gmail not marking everything as spam...

+syzkaller mailing list as this does not seem to appear anywhere on open web

--f403045f077418fba90549ce57e8
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
--f403045f077418fba90549ce57e8--
