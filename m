From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 16:31:04 +0000
Message-ID: <1507912260.13345.0.camel@wdc.com>
References: <20171012183704.22326-1-ming.lei@redhat.com>
         <20171012183704.22326-5-ming.lei@redhat.com>
         <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
         <20171013001919.GA24715@ming.t460p>
         <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
         <20171013160731.GA30899@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013160731.GA30899@ming.t460p>
Content-Language: en-US
Content-ID: <994C37A8795CB94FB0747DBD27D1A885@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE3LTEwLTE0IGF0IDAwOjA3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gQWN0
dWFsbHkgaXQgaXMgaW4gaG90IHBhdGgsIGZvciBleGFtcGxlLCBscGZjIGFuZCBxbGEyeHgncyBx
dWV1ZSBkZXB0aCBpcyAzLA0KDQpTb3JyeSBidXQgSSBkb3VidCB3aGV0aGVyIHRoYXQgaXMgY29y
cmVjdC4gTW9yZSBpbiBnZW5lcmFsLCBJIGRvbid0IGtub3cgYW55IG1vZGVybg0Kc3RvcmFnZSBI
QkEgZm9yIHdoaWNoIHRoZSBkZWZhdWx0IHF1ZXVlIGRlcHRoIGlzIHNvIGxvdy4NCg0KQmFydC4=
