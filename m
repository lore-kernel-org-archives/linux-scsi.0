From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 17:06:54 +0000
Message-ID: <1519751213.23791.3.camel@wdc.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
         <1519700898.3120.3.camel@wdc.com>
         <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
         <1519702875.3120.7.camel@wdc.com>
         <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
         <1519708355.3120.9.camel@wdc.com>
         <478f40f1-d86c-ee5f-daaf-6332b67fe721@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <478f40f1-d86c-ee5f-daaf-6332b67fe721@oracle.com>
Content-Language: en-US
Content-ID: <32D1BF44E365E74FBA4F004FE9D79AB0@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTAyLTI3IGF0IDEzOjE1ICswODAwLCBqaWFuY2hhby53YW5nIHdyb3RlOg0K
PiBDYW4geW91IHNoYXJlIG1vcmUgZGV0YWlscyBhYm91dCB0aGlzID8gDQoNCkFmdGVyIGhhdmlu
ZyBoYWQgYW5vdGhlciBsb29rLCBJIHRoaW5rIHlvdXIgcGF0Y2ggaXMgZmluZS4gU28gaWYgeW91
IHdhbnQgeW91DQpjYW4gYWRkOg0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0
LnZhbmFzc2NoZUB3ZGMuY29tPg0KDQoNCg==
