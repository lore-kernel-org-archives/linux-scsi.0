From: jthumshirn <jthumshirn@suse.de>
Subject: Re: [RESEND PATCH v2 0/2] Update SCSI target removal path
Date: Thu, 31 Mar 2016 08:58:39 +0200
Message-ID: <31317011e72e1beb610c6ba3a28ee92c@suse.de>
References: <cover.1459249252.git.jthumshirn@suse.de>
 <1459356208.2509.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459356208.2509.9.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-03-30 18:43, James Bottomley wrote:
> On Wed, 2016-03-30 at 09:09 +0200, Johannes Thumshirn wrote:
>> [resend with linux-scsi@ in Cc, my apologies]
>> 
>> This is a follow up to "scsi: Add intermediate STARGET_REMOVE state
>> to scsi_target_state".
>> 
>> If anyone has an idea how to create a regression test suite for the
>> target removal path I'd be all ears, given the fact that this is the
>> 3rd or 4th patch targeting it.
> 
> Actually, could you reverse the order of these patches, please.  It's
> not safe to revert the soft lockup fix until after the intermediate
> state is introduced.  I'd rather we didn't go through a point in the
> tree where the bug exists again.

You're right. I'll resend the series in reverse order.
