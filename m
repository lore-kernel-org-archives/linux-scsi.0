From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] Fixing large block devices on 32 bit
Date: Fri, 31 Jan 2014 15:16:11 -0800
Message-ID: <1391210171.2172.54.camel@dabdike.int.hansenpartnership.com>
References: <1391194978.2172.20.camel@dabdike.int.hansenpartnership.com>
	 <20140131192617.GA14098@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140131192617.GA14098@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-01-31 at 14:26 -0500, Dave Jones wrote:
> On Fri, Jan 31, 2014 at 11:02:58AM -0800, James Bottomley wrote:
>  
>  > it will only be a couple of years before 16TB devices are
>  > available.  By then, I bet that most arm (and other exotic CPU) Linux
>  > based personal file servers are still going to be 32 bit, so they're not
>  > going to be able to take this generation (or beyond) of drives. 
>  > 
>  >      1. Try to pretend that CONFIG_LBDAF is supposed to cap out at 16TB
>  >         and there's nothing we can do about it ... this won't be at all
>  >         popular with arm based file server manufacturers.
> 
> Some of the higher end home-NAS's have already moved from arm/ppc -> x86_64[1]
> Unless ARM64 starts appearing at a low enough price point, I wouldn't be 
> surprised to see the smaller vendors do a similar move just to stay competitive.
> (probably while keeping 'legacy' product lines for a while at a cheaper pricepoint
>  that won't take bigger disks).

So yould you bet on the problem solving itself *before* we get 16TB
disks?  Because if we ignore it, that's the bet we're making.

James


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
