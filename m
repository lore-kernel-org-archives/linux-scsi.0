From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 14:30:39 -0700
Message-ID: <fb52d9c5-b392-96eb-c6db-99c603be80d1@wdc.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
 <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
 <20180621081900.GA5183@lst.de>
 <84a5b54c318b130f47775747d37dc139c27ebda7.camel@wdc.com>
 <20180621211529.GA27589@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621211529.GA27589@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On 06/21/18 14:12, Keith Busch wrote:
> On Thu, Jun 21, 2018 at 06:21:09PM +0000, Bart Van Assche wrote:
>> That's not how the SCSI core works.
> 
> How does it work? Jianchao is advocating for holes in software
> to ignore reacting to hardware events and force unnecessary error
> escalation. Putting holes in kernel software can't possibly be our
> only recourse.

Why were the patch "blk-mq: Remove generation seqeunce" and related 
patches rushed upstream without having given anyone a chance to review 
these patches? The approach of these patches is inferior to at least one 
alternative that was available. The code that is currently upstream
spreads the request state over multiple (three) variables while an 
alternative approach was presented that stores the request state in a 
single variable. I think the number of fix-up patches that is needed for 
the approach that is currently upstream shows that the upstream approach 
is inferior. I'm referring to "[PATCH v14] blk-mq: Rework blk-mq timeout 
handling again" (https://marc.info/?l=linux-block&m=152703042412228).

Bart.
