From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 3/3] target: Use scsi helpers to build the sense data
 correctly
Date: Mon, 6 Jul 2015 15:29:55 +0300
Message-ID: <559A74C3.1070900@dev.mellanox.co.il>
References: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
 <1436169747-28834-4-git-send-email-sagig@mellanox.com>
 <20150706090654.GC15996@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150706090654.GC15996@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 7/6/2015 12:06 PM, Christoph Hellwig wrote:
> On Mon, Jul 06, 2015 at 11:02:27AM +0300, Sagi Grimberg wrote:
>> Instead of open coding the sense buffer construction, use
>> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
>> helpers which moved to scsi_common.
>>
>> This patch also fixes wrong setting of descriptor format sense data
>> for t10-pi integrity errors.
>
> Please split this into three patches:
>
>   1) move the helpers to scsi_common.c
>   2) use helpers in the target code
>   3) always use descriptor-type sense data for PI errors
>

Easy enough.

Thanks.
