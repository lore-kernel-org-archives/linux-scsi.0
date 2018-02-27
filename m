From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 05:12:36 +0000
Message-ID: <1519708355.3120.9.camel@wdc.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
         <1519700898.3120.3.camel@wdc.com>
         <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
         <1519702875.3120.7.camel@wdc.com>
         <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
Content-Language: en-US
Content-ID: <32AC73E3167C964C8D99FD26ACC50304@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTAyLTI3IGF0IDEyOjAwICswODAwLCBqaWFuY2hhby53YW5nIHdyb3RlOg0K
PiBPbiB0aGUgb3RoZXIgaGFuZCwgdGhpcyBwYXRjaCBpcyB0byBhbGlnbiB0aGUgYWN0aW9ucyBi
ZXR3ZWVuIGJsay1tcSBhbmQgYmxvY2sNCj4gbGVnYWN5IGNvZGUgaW4gX19zY3NpX3F1ZXVlX2lu
c2VydC4NCg0KSGVsbG8gSmlhbmNoYW8sDQoNClNpbmNlIHRoZSBsZWdhY3kgU0NTSSBjb3JlIHVu
cHJlcHMgYW4gcmVwcmVwYXJlcyBhIHJlcXVlc3Qgd2hlbiByZXF1ZXVpbmcgaXQgSQ0KdGhpbmsg
eW91ciBwYXRjaCBkb2VzIG5vdCBhbGlnbiB0aGUgYmxrLW1xIGFuZCBsZWdhY3kgYmxvY2sgbGF5
ZXIgYWN0aW9ucyBidXQNCmluc3RlYWQgbWFrZXMgdGhlIGJlaGF2aW9yIG9mIHRoZSB0d28gY29k
ZSBwYXRocyBkaWZmZXJlbnQuDQoNClRoYW5rcywNCg0KQmFydC4NCg0KDQoNCg==
