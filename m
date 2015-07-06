From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 1/3] target: Inline transport_get_sense_codes()
Date: Mon, 6 Jul 2015 15:28:45 +0300
Message-ID: <559A747D.7000404@dev.mellanox.co.il>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
 <1436169747-28834-2-git-send-email-sagig@mellanox.com>
 <20150706085958.GA15996@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150706085958.GA15996@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 7/6/2015 11:59 AM, Christoph Hellwig wrote:
> On Mon, Jul 06, 2015 at 11:02:25AM +0300, Sagi Grimberg wrote:
>> From: Bart Van Assche <bart.vanassche@sandisk.com>
>>
>> Inline this function in its call site since it performs a trivial
>> task and since it is only called once.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Sagi: if you send on Barts patches you probably should add your signoff
> as well.

I will. Thanks.
