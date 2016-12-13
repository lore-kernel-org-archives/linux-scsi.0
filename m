From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: version 3.18.44 to 3.18.45 introduced a bug in
 "drivers/scsi/megaraid/megaraid_sas_base.c"
Date: Tue, 13 Dec 2016 08:47:33 -0800
Message-ID: <20161213164733.GA21910@kroah.com>
References: <23B7B563BA4E9446B962B142C86EF24ADB6F24@CNMAILEX03.lenovo.com>
 <a9788b9c-6361-f79e-f851-e8c4871571cb@infradead.org>
 <20161213163013.GB20693@kroah.com>
 <f08db306-7e67-ff4d-979d-8baa82c40671@infradead.org>
 <1481647421.2473.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481647421.2473.36.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Dashi DS1 Cao <caods1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 13, 2016 at 08:43:41AM -0800, James Bottomley wrote:
> On Tue, 2016-12-13 at 08:33 -0800, Randy Dunlap wrote:
> > On 12/13/16 08:30, Greg Kroah-Hartman wrote:
> > > I don't maintain 3.18-stable :)
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Thanks. My bad.
> > 
> > adding Sasha.
> 
> This was all covered here:
> 
> https://www.spinics.net/lists/stable/msg150608.html
> 
> How did it get missed, and what should the process be?

I don't know how that got missed, did the "fixup" patch never make it
into 3.18-stable?  I know Sasha has been slow on that kernel, and it's
about to go end-of-life, so perhaps he's just releasing them on a slower
cycle at the moment...

thanks,

greg k-h
