From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Wed, 21 Jan 2009 20:44:45 +0200
Message-ID: <49776D1D.6000206@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org>	<1231802758.27151.18.camel@localhost.localdomain>	<496C9ABE.8060300@garzik.org>	<20090113140328.3aab5a35@lxorguk.ukuu.org.uk>	<496CA26E.1080708@garzik.org> <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk> <496CCD9F.2000401@panasas.com> <497765E6.4030108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <497765E6.4030108@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> BTW, where can the latest libosd be found?
> 
> I'll want to use that for osdblk (export a single OSD object as a Linux 
> block device).
> 
> 	Jeff
> 

You are most welcome thank you.

The in kernel patches are at:
  git-clone git://git.open-osd.org/linux-open-osd.git linux-next
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next

But you might find the out-of-tree project more complete:
  git-clone git://git.open-osd.org/open-osd.git
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=refs/heads/exofs

To setup an osd-target and all that, this is also hosted on open-osd.org
Please start reading at http://open-osd.org and the links from that page.
(Been first, you get to debug my documentation)

I'm patiently awaiting patches ;)

sincerely yours
Boaz
