From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 19 May 2005 20:54:57 -0500
Message-ID: <428D4371.6020809@cybsft.com>
References: <20050516085832.GA9558@gmail.com>	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>	 <1116354894.4989.42.camel@mulgrave> <428C030E.8030102@cybsft.com>	 <1116476630.5867.2.camel@mulgrave>  <20050519095143.GA3972@in.ibm.com>	 <1116546970.5037.137.camel@mulgrave>  <428D37CF.5070903@cybsft.com>	 <1116551853.5037.145.camel@mulgrave>  <428D3E1C.2020802@cybsft.com> <1116553229.5037.155.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay00.pair.com ([209.68.1.20]:29454 "HELO relay.pair.com")
	by vger.kernel.org with SMTP id S261261AbVETBy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 21:54:58 -0400
In-Reply-To: <1116553229.5037.155.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-05-19 at 20:32 -0500, K.R. Foley wrote:
> 
>>Any idea why I can't set the period to 12.5? I am going to see if
>>anything jumps out at me.
> 
> 
> what's the dt setting? if it's zero, try setting it to one and then
> lowering the period to 12.5 but don't trigger a revalidate this time,
> try reading or writing to the disk and then see what the settings come
> back as.
> 
> James
> 
> 
> 
the dt setting is 0. can't set it to 1, at least not so that you can see
it stay that way. tried setting period to 12.5, stays at 25. min_period
is set to 12.5 but doesn't seem to matter. what's next :)

-- 
   kr
