From: Hannes Reinecke <hare@suse.de>
Subject: Re: [REGRESSION][v4.13.y][v4.14.y] scsi: libsas: allow async aborts
Date: Fri, 17 Nov 2017 15:09:37 +0100
Message-ID: <100fda00-3da4-1bf1-eaf2-fc0b4fb4fe37@suse.de>
References: <27d1c9b1-9a80-4982-290b-3916d6e5c80f@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <27d1c9b1-9a80-4982-290b-3916d6e5c80f@canonical.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>, hch@lst.de
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de, bart.vanassche@wdc.com, bblock@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jth@kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org, 1726519@bugs.launchpad.net
List-Id: linux-scsi@vger.kernel.org

On 11/16/2017 11:08 PM, Joseph Salisbury wrote:
> Hi Christoph,
> 
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
> 
> 909657615d9b ("scsi: libsas: allow async aborts")
> 
>      
> The regression was introduced as of v4.12-rc1, and it still exists in
> 4.14 mainline.
> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
> 
I'll be checking what's going on there.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
