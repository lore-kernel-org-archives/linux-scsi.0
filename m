From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RFC] target: Use scsi helpers to build the sense data
 correctly
Date: Sun, 5 Jul 2015 10:00:53 +0300
Message-ID: <5598D625.5090900@dev.mellanox.co.il>
References: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
 <20150703161236.GA32744@infradead.org> <5597B9E3.70901@dev.mellanox.co.il>
 <55980055.3010007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55980055.3010007@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 7/4/2015 6:48 PM, Bart Van Assche wrote:

>>> Bart, any chance you could resend them?
>>>
>>
>> Bart, would you prefer to re-send your changes on top of v1 of this one?
>> It should be easy enough.
>>
>> The modification needed is that struct sense_info needs a desc_format
>> bool to indicate if the sense data is constructed in a descriptor
>> format sense data or not.
>
> Hello Sagi,
>
> Since Christoph asked you to rework your patch, let's start with the
> patches about which there is no discussion. I will post the first two
> patches referred to above next week. The third patch referred to by
> Christoph needs more thought before I can send it upstream.

OK, I converted my patch to apply over your patches. If you don't mind,
I will post them together with my patch so Nic won't need to handle the
dependencies?

Sagi.
