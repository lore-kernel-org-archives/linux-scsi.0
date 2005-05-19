From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Wed, 18 May 2005 22:07:58 -0500
Message-ID: <428C030E.8030102@cybsft.com>
References: <20050516085832.GA9558@gmail.com>	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>	 <1116340465.4989.2.camel@mulgrave>  <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.pair.com ([209.68.5.17]:40210 "HELO relay03.pair.com")
	by vger.kernel.org with SMTP id S262457AbVESDH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 23:07:59 -0400
In-Reply-To: <1116354894.4989.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2005-05-17 at 22:38 +0530, Dinakar Guniguntala wrote:
> 
>>May  9 12:03:32 llm09 kernel:   Vendor: IBM CORP  Model: GEM312 V002       Rev: 4.1b
>>May  9 12:03:32 llm09 kernel:   Type:   Processor                          ANSI SCSI revision: 02
> 
> 
> OK, that's roughly what I was expecting.  These processor chips tend to
> be rather basic when it comes to rates and widths.
> 
> The root cause, I think, is that the aic7xxx isn't starting out at async
> narrow for the first inquiry (because the original DV code I removed did
> this, and I didn't add an equivalent back).  The latest aic7xxx patch
> should sort this out.
> 
> So, to get all of these changes, could you start with vanilla linus
> kernel 2.6.12-rc4 (or tree based on this, but not -mm which already has
> some of the SCSI tree included) and then apply the SCSI patch at
> 
> http://parisc-linux.org/~jejb/scsi_diffs/scsi-misc-2.6.diff
> 
> and see if it works?
> 
> Thanks,
> 
> James
> 

James,

This also solves my problem that I reported in this thread
http://marc.theaimsgroup.com/?l=linux-scsi&m=111422854418964&w=2

-- 
   kr
