From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2 2/2] blk-mq: fix blk_mq_tagset_busy_iter
Date: Thu, 2 Aug 2018 18:46:52 +0000
Message-ID: <6f5d30bf747641778164335a64255bd7a027bc4c.camel@wdc.com>
References: <20180802174937.15444-1-ming.lei@redhat.com>
         <20180802174937.15444-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802174937.15444-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <1FDE5ECA0F961745B8D4B6E4A69BFB6D@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux@roeck-us.net" <linux@roeck-us.net>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "broonie@kernel.org" <broonie@kernel.org>, "matthew.hart@linaro.org" <matthew.hart@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-08-03 at 01:49 +-0800, Ming Lei wrote:
+AD4- Commit d250bf4e776ff09d5(+ACI-blk-mq: only iterate over inflight requ=
ests
+AD4- in blk+AF8-mq+AF8-tagset+AF8-busy+AF8-iter+ACI-) uses 'blk+AF8-mq+AF8=
-rq+AF8-state(rq) +AD0APQ- MQ+AF8-RQ+AF8-IN+AF8-FLIGHT'
+AD4- to replace 'blk+AF8-mq+AF8-request+AF8-started(req)', this way is wro=
ng, and causes
+AD4- lots of test system hang during booting.
+AD4-=20
+AD4- Fix the issue by using blk+AF8-mq+AF8-request+AF8-started(req) inside=
 bt+AF8-tags+AF8-iter().

That's a good catch. Hence:

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-
