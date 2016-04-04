From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 1/2] scsi: Add intermediate STARGET_REMOVE state to
 scsi_target_state
Date: Mon, 04 Apr 2016 11:39:42 +0200
Message-ID: <bf85a3a04dd0db5e02f27d810b8d93f9@suse.de>
References: <cover.1459428540.git.jthumshirn@suse.de>
 <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459428540.git.jthumshirn@suse.de>
 <1459614980.2306.5.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459614980.2306.5.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-04-02 18:36, James Bottomley wrote:
> On Thu, 2016-03-31 at 14:53 +0200, Johannes Thumshirn wrote:
>> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid
>> running
>> into the BUG_ON() in scsi_target_reap().
>> 
>> This intermediate state is only valid in the path from
>> scsi_remove_target() to
>> scsi_target_destroy() indicating this target is going to be removed.
>> 
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
> 
> The code and ordering is fine with me, so you can add
> 
> Reviewed-by: James Bottomley <jejb@linux.vnet.ibm.com>
> 
> However, I'd really appreciate it if the description of what was going
> on was clearer for a non-SUSE distro maintainer.  What we're doing is
> applying a more comprehensive fix for a previously hack fixed problem
> and then reverting the hack.  I think message 1 should say "this
> refixes the problem introduced by commit X in a more comprehensive way"
> 
> and message 2 "Now that we've done a more comprehensive fix with the
> intermediate target state in patch Y, we can remove the previous hack"
> 
> James

OK, I'll try my very best. Thanks for the review.
