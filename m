From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: [PATCH] ips driver for 2.4.23-pre4
Date: Fri, 9 Jan 2004 07:35:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190129F9@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:32949 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261575AbUAIMg2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 07:36:28 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

James,

OK by me ...  I have no problem at all with that. 

Jack


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, January 08, 2004 4:16 PM
To: Hammer, Jack
Cc: Christoph Hellwig; Xose Vazquez Perez; linux-scsi; Tosatti
Subject: RE: [PATCH] ips driver for 2.4.23-pre4

On Thu, 2004-01-08 at 15:18, Hammer, Jack wrote:
> The reason this compiler warning exists is that these are the only 
> hardware platforms that support this adapter.  Use of this adapter is 
> any other box can cause serious problems and is not supported by 
> anyone.  Removal of this warning has no effect on the executable code 
> and would not improve the driver in my opinion.  If I was including a 
> module in my system that is not going to work, I'd like to know about it.
[...]
> > -#if !defined(__i386__) && !defined(__ia64__) -#error "This driver 
> > has only been tested on the x86/ia64 platforms"
> > +#if !defined(__i386__) && !defined(__ia64__) && 
> > +!defined(__x86_64__) #error "This driver has only been tested on 
> > +the x86/ia64/x86_64
> platforms"
> >  #endif

This is actually an #error though, not a #warning...could we at least
downgrade it to #warning (like has already been done for ips) so I don't get
spurious compile failure reports from people doing make allyes
configurations on non-x86 boxes?

Thanks,

James


