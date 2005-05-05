From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] add open iscsi netlink interface to iscsi
	transport class
Date: Thu, 05 May 2005 07:45:47 -0400
Message-ID: <1115293547.6052.1.camel@localhost.localdomain>
References: <E1DTehn-0005gJ-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s-utl01-nypop.stsn.com ([199.106.90.52]:61099 "HELO
	s-utl01-nypop.stsn.com") by vger.kernel.org with SMTP
	id S261944AbVEEXxV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2005 19:53:21 -0400
In-Reply-To: <E1DTehn-0005gJ-00@gondolin.me.apana.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: YOSHIFUJI Hideaki / ???? <yoshfuji@linux-ipv6.org>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, netdev@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, 2005-05-05 at 21:39 +1000, Herbert Xu wrote:
> YOSHIFUJI Hideaki / ???? <yoshfuji@linux-ipv6.org> wrote:
> > In article <42798AC1.2010308@cs.wisc.edu> (at Wed, 04 May 2005 19:53:53 -0700), Mike Christie <michaelc@cs.wisc.edu> says:
> > 
> >> +struct iscsi_uevent {
> > :
> >> +} __attribute__ ((aligned (sizeof(unsigned long))));
> > 
> > I think it'd be better to use sizeof(uint64_t) or something.
> 
> Is there a benefit in aligning on 64-bit boundaries for 32-bit platforms?


why align at all as opposed to just letting the compiler figure it out.



