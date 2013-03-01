From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 01 Mar 2013 17:14:38 +0100
Message-ID: <5130D3EE.4090205@acm.org>
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/01/13 10:19, James Bottomley wrote:
> This is an assorted set of stragglers into the merge window with driver
> updates for qla2xxx, megaraid_sas, storvsc and ufs.  It also includes
> pulls of the uapi tree (all the remaining SCSI pieces) and the fcoe tree
> (updates to fcoe and libfc)

Hello James,

I'm curious to know your opinion about the patch called "Fix race 
between starved list processing and device removal" 
(http://article.gmane.org/gmane.linux.scsi/80090/match=scsi_run_queue) ? 
It was posted for the first time several months ago and has been ack-ed 
and tested by other people. So far I haven't seen any comments from you 
on that patch.

Bart.
