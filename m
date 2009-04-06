From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PATCH] final set of SCSI updates for the merge window
Date: Mon, 06 Apr 2009 20:11:32 +0300
Message-ID: <49DA37C4.4090208@panasas.com>
References: <1239033266.3641.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756967AbZDFRME@vger.kernel.org>
In-Reply-To: <1239033266.3641.9.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/06/2009 06:54 PM, James Bottomley wrote:
> This is just an assorted set of driver updates (fcoe, qla2x, stex etc.)
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The short changelog is:
> 
> 
<snip>
> Hannes Reinecke (1):
>       aic7xxx: leaves timer running on init failure
> 

I was hoping you would also include this patch:

http://www.spinics.net/lists/linux-scsi/msg34174.html
Tested-by: Boaz Harrosh <bharrosh@panasas.com>

After Hannes explained it looks totally un-dangerous, I've
been running with it ever since.

It does remove that annoying dmsg warning every scsi ULD
has.

<snip>

Thanks
Boaz
