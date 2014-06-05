From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/2] libiscsi, iser: Adjust data_length to include protection
 information
Date: Thu, 05 Jun 2014 20:26:37 +0300
Message-ID: <5390A84D.4060504@dev.mellanox.co.il>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com> <1401639581-20111-2-git-send-email-sagig@mellanox.com> <538DF3CA.7030506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <538DF3CA.7030506@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

On 6/3/2014 7:11 PM, Mike Christie wrote:
> On 06/01/2014 11:19 AM, Sagi Grimberg wrote:
>>   /**
>> + * iscsi_adjust_dl - Adjust SCSI data length to include PI
>> + * @sc: scsi command.
>> + * @data_length: command data length.
>> + *
>> + * Adjust the data length to account for how much data
>> + * is actually on the wire.
>> + *
>> + * returns the adjusted data length
>> + **/
>> +static unsigned
>> +iscsi_adjust_dl(struct scsi_cmnd *sc, unsigned data_len)
> Hey, one other comment. Could you rename this to iscsi_adjust_data_len
> or iscsi_adjust_dlength? It is more common in the iscsi code to use
> those names for data length.

No need - I moved this logic to a scsi helper anyway (as MKP suggested)...

Thanks!
Sagi.
