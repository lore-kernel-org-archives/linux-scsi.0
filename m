From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Mon, 16 Nov 2015 13:47:08 -0800
Message-ID: <564A4EDC.8060805@suse.com>
References: <cover.1444241058.git.lduncan@suse.com>
 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
 <1444830904.2220.28.camel@HansenPartnership.com> <561EA018.7020700@suse.com>
 <1444848835.2220.50.camel@HansenPartnership.com> <5644BEE1.3010208@suse.com>
 <yq1ziyhy38c.fsf@sermon.lab.mkp.net> <5649C79E.9070603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5649C79E.9070603@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 11/16/2015 04:10 AM, Hannes Reinecke wrote:
> On 11/13/2015 10:54 PM, Martin K. Petersen wrote:
>>>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:
>>
>>>> Well, I'm a bit worried about the loss of a monotonically increasing
>>>> host number from the debugging perspective.  Right now, if you look
>>>> at any log, hostX always refers to one and only one incarnation
>>>> throughout the system lifetime for any given value of X.
>>
>> That's a feature that I would absolutely hate to lose. I spend a huge
>> amount of time looking at system logs.
>>
> Right. Then have it enabled via a modprobe parameters.
> 
> We actually had customers running into a host_no overflow due to
> excessive host allocations and freeing done by iSCSI.
> 
> Cheers,
> 
> Hannes
> 

Martin: I will be glad to update the patch, creating a modprobe
parameter as suggested, if you find this acceptable.
-- 
Lee Duncan
SUSE Labs
