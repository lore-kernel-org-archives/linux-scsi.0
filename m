From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] scsi tgt updates (replace the elevator code)
Date: Thu, 06 Apr 2006 21:13:17 -0500
Message-ID: <4435CABD.7000200@cs.wisc.edu>
References: <20060316090410E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52398 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932283AbWDGCN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2006 22:13:26 -0400
In-Reply-To: <20060316090410E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Here's another patchset to synchronize the scsi-target git tree with
> the latest code in the subversion repository. This patchset replaces
> the elevator code with a simple list.
> 
> This patchset assumes that the previous patchset is applied.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114199144502121&w=2
> -

Hey James the patchset referred to in this mail, this patchset and the 
"[PATCH] scsi tgt: add task management function support" patch did not 
get merged to the tgt merged. Did you want us to resend the patchsets or 
did you not like them, or do you wnat them in one nice large patchset? 
Or did you want us to ask Jens to merge some of the not so controversial 
block layer stuff like "[PATCH 4/6] block layer: use blk_rq_bio_prep in 
init_request_from_bio" first? Thanks.
