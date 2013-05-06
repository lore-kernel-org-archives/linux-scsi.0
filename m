From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables
 and modify for SPC
Date: Mon, 06 May 2013 11:27:30 -0700
Message-ID: <1367864850.1868.33.camel@dabdike>
References: <51703A99.5030605@pmc-sierra.com>
	 <1367532744.3133.13.camel@dabdike>
	 <E5DEE6F468524847995699AD11E80885013304BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
	 <1367560743.24627.5.camel@dabdike>
	 <E5DEE6F468524847995699AD11E80885017C76B6@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43696 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab3EFS1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 14:27:32 -0400
In-Reply-To: <E5DEE6F468524847995699AD11E80885017C76B6@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, sakthivel.sk@hcl.com, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

On Mon, 2013-05-06 at 09:48 -0700, Anand Kumar Santhanam wrote:
> Hi James,
> 
> I have resubmitted the patchset after fixing the array out of bounds
> issue. Pls pull the same.
> 
> I guess I did not make myself clear with my earlier mail. I compiled my
> earlier patchset using the 
> Kernel Makefile and I did not get the array out of bounds warning even I
> had -Wall -O2 flags enabled.
> So I was just wondering whether you are using any special settings such
> that you are able to see the 
> warning.

Oh, OK, that's not what I read in the email, so sorry for being brusque.
What -Wall actually does is highly gcc version dependent.  What I did
was simply a standard kernel compile (no extra flags), but with
gcc-4.7.2

James


