From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/6] Fixes for ibmvscsis driver
Date: Mon, 17 Oct 2016 09:15:18 -0700
Message-ID: <7e450d09-64a7-d32f-d332-289152b8c912@linux.vnet.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
 <8fcdcfd1eedecae72a868ab45a872e06@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <8fcdcfd1eedecae72a868ab45a872e06@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: Steven Royer <seroyer@linux.vnet.ibm.com>, Michael Cyr <mikecyr@us.ibm.com>
Cc: nab@linux-iscsi.org, joe@perches.com, hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 10/14/2016 03:25 PM, Steven Royer wrote:
> On 2016-10-13 11:02, Michael Cyr wrote:
>> Various fixes and cleanups for the ibmvscsis driver.
>> The first is a sort of prequel to the second, which is the primary
>> change (and the biggest).  The rest are fairly small fixes.
>>
>> Michael Cyr (6):
>>   ibmvscsis: Rearrange functions for future patches
>>   ibmvscsis: Synchronize cmds at tpg_enable_store time
>>   ibmvscsis: Synchronize cmds at remove time
>>   ibmvscsis: Clean up properly if target_submit_cmd/tmr fails
>>   ibmvscsis: Return correct partition name/# to client
>>   ibmvscsis: Issues from Dan Carpenter/Smatch
>>
>>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1096 
>> +++++++++++++-----------------
>>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |    5 +-
>>  2 files changed, 494 insertions(+), 607 deletions(-)
> 
> I've tested with this patch.  Seems to fix cleanup issues, in particular 
> after a target is removed or at target reboot time.
> Signed-off-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> 

I think the "Tested-by" tag is more appropriate seeing as you tested the
patch.

-Tyrel
