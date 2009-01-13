From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Tue, 13 Jan 2009 16:14:50 +0000
Message-ID: <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk>
References: <4947BFAA.4030208@panasas.com>
	<4947CA5C.50104@panasas.com>
	<20081229121423.efde9d06.akpm@linux-foundation.org>
	<495B8D90.1090004@panasas.com>
	<1230739053.3408.74.camel@localhost.localdomain>
	<4960D3CA.2000202@panasas.com>
	<1231783926.3256.29.camel@localhost.localdomain>
	<496B989F.7050907@garzik.org>
	<1231790190.15161.29.camel@localhost.localdomain>
	<496BA671.3070900@garzik.org>
	<1231802758.27151.18.camel@localhost.localdomain>
	<496C9ABE.8060300@garzik.org>
	<20090113140328.3aab5a35@lxorguk.ukuu.org.uk>
	<496CA26E.1080708@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <496CA26E.1080708@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > Now in my experience that is a *dumb* question because the answer is
> > obvious...
> 
> The choice is between "new magic OSD fs" and "new fs that used to be 
> ext4, before we hacked it up".
> 
> "existing one you trust" is not an option...

No it isn't. The choice is existing technology followed by a "thank you
goodbye Mr OSD salesman".

I'm not saying we shouldn't work on an OSD file system and I'm glad IBM
folks are but that it can be done slowly. Also for most fs folks an OSD
emulator testing might not be a bad idea - say one stacked on ext3 8)


