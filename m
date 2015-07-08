From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 2/5] target: Split
 transport_send_check_condition_and_sense()
Date: Wed, 8 Jul 2015 13:24:33 +0300
Message-ID: <559CFA61.4000806@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-3-git-send-email-sagig@mellanox.com>
 <20150708101551.GA14466@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150708101551.GA14466@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 7/8/2015 1:15 PM, Christoph Hellwig wrote:
>> +	if (r == (__force int)TCM_CHECK_CONDITION_UNIT_ATTENTION) {
>
> You probably want to compare reason here to avoid the cast.
>

I do want it...
