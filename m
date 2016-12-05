From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v3 3/6] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Mon, 5 Dec 2016 21:20:29 +0000
Message-ID: <E7E85367-D1EF-44D9-A752-FC20B4BA68D0@cavium.com>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
 <20161205125530.GB23221@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0053.outbound.protection.outlook.com ([104.47.32.53]:64769
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751570AbcLEVUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 16:20:31 -0500
In-Reply-To: <20161205125530.GB23221@infradead.org>
Content-Language: en-US
Content-ID: <3C9AE9CD87315940B8120A53A510AAB9@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQoNCk9uIDEyLzUvMTYsIDQ6NTUgQU0sICJDaHJpc3RvcGggSGVsbHdpZyIgPGhjaEBpbmZyYWRl
YWQub3JnPiB3cm90ZToNCg0KPj4rCXZvaWQgKmhhbmRsZTsNCj4NCj5KdXN0IGN1cmlvdXM6IHdo
eSBkbyB5b3UgbmVlZCB0aGlzIG5ldyBoYW5kbGUgZmllbGQgaW5zdGVhZCBvZiBqdXN0DQo+cGFz
c2luZyB0aGUgcnNwIGFzIHRoZSBvbGQgY29kZSBkaWQ/DQoNCldlIHdhbnRlZCB0byBtYWtlIGl0
IG1vcmUgZ2VuZXJpYyBwb2ludGVyIHdpdGggbmV3IFEtcGFpciBmcmFtZXdvcmtzLiANClNvIGp1
c3QgcmVuYW1lZCBpdC4gd2XigJlsbCByZW1vdmUgb2xkIHJzcCByZWZlcmVuY2UgaW4gcmV3b3Jr
ZWQgcGF0Y2guIA0K
