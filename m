From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] mpt2sas: fix non-x86 crash on shutdown
Date: Wed, 04 Jan 2012 14:39:29 -0500 (EST)
Message-ID: <20120104.143929.962116161801444281.davem@davemloft.net>
References: <1325690398.2758.10.camel@dabdike.int.hansenpartnership.com>
	<1325690713.2758.13.camel@dabdike.int.hansenpartnership.com>
	<20120104192102.GB18214@kroah.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120104192102.GB18214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: greg@kroah.com
Cc: James.Bottomley@HansenPartnership.com, Nagalakshmi.Nandigama@lsi.com, stable@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com
List-Id: linux-scsi@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 4 Jan 2012 11:21:02 -0800

> On Wed, Jan 04, 2012 at 09:25:13AM -0600, James Bottomley wrote:
>> From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>
> 
> That's not a correct "from" line, sorry.  That would create a mess of
> the log.  Oh, I see Linus's tree is already a mess here, ugh.  Please be
> more careful when accepting patches, otherwise stuff like this causes me
> to have to hand-edit the kernel git logs when I run the "who does what"
> statistic reports...
> 
> David, any objection for me taking this patch (left below) instead of
> your original one for the stable tree?

No objection.
