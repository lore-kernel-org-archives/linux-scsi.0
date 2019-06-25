From: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Subject: Re: [PATCH 3/4] scsi: sd_zbc: add zone open, close, and finish
 support
Date: Tue, 25 Jun 2019 12:32:24 +0200
Message-ID: <62457020-b543-e08d-54fe-e8dc92d94e47@lightnvm.io>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-4-mb@lightnvm.io>
 <db952c97-b5c9-9276-ea51-c14064c5a093@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db952c97-b5c9-9276-ea51-c14064c5a093@acm.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 6/24/19 9:46 PM, Bart Van Assche wrote:
> On 6/21/19 6:07 AM, Matias Bjørling wrote:
>> + * @op: Operation to be performed
> 
> This description could be more clear.
> 
> Thanks,
> 
> Bart.

Thanks Bart. I'll update it.
