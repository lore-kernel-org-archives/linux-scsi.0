From: Praveen Murali <pmurali@logicube.com>
Subject: Re: [PATCH v1] Fix sector number translation in sense buffer for
 SATA drives
Date: Fri, 22 Jun 2012 10:05:26 -0700
Message-ID: <1340384726.3712.77.camel@praveen-debian.lg.local>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
	 <CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
	 <1340324637.3712.67.camel@praveen-debian.lg.local>
	 <CABE8wws6w0uWhskDJZPuKr3S1_qwo8M1vy-q8CuvJs=C1BRs2A@mail.gmail.com>
	 <33E83F701EA663469FEBA23868D25955026B43DA@lgsbs.lg.local>
	 <1340338888.13003.9.camel@dwillia2-mobl>
	 <33E83F701EA663469FEBA23868D25955026B43DB@lgsbs.lg.local>
	 <CABE8wwvwuwi9aAc63fh-Gx9GdH45_5WTbMN8qUSEzZfyKg6EQg@mail.gmail.com>
Reply-To: pmurali@logicube.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:50116 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2FVRGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 13:06:19 -0400
In-Reply-To: <CABE8wwvwuwi9aAc63fh-Gx9GdH45_5WTbMN8qUSEzZfyKg6EQg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>

On Thu, 2012-06-21 at 22:41 -0700, Dan Williams wrote:
> On Thu, Jun 21, 2012 at 10:27 PM, Praveen Murali <pmurali@logicube.com> wrote:
> > agreed, this looks way more cleaner. can you please commit these changes?
> >
> 
> Sure I can push this, can you test it out to make sure it fixes your
> failing case?  Then I'll push it with your reported-by and tested-by.
> 
> Much appreciated.
Dan,
  I tested your change and it looks good. It fixes the problem for me.

Thanks,
Praveen
> 
> --
> Dan

