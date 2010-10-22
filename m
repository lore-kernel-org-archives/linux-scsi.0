From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 22 Oct 2010 10:56:24 -0700
Message-ID: <20101022175624.GA13640@kroah.com>
References: <4CA653F0.1010008@vlnb.net>
 <4CA656AD.8020408@vlnb.net>
 <20101009212047.GB27180@kroah.com>
 <4CB36592.6060909@vlnb.net>
 <20101011213235.GA11489@kroah.com>
 <4CB4AEB9.30501@vlnb.net>
 <20101012190345.GA25737@kroah.com>
 <4CB75E81.7000208@vlnb.net>
 <20101014200413.GA30831@kroah.com>
 <4CC1CA4D.1090609@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CC1CA4D.1090609@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2010 at 09:30:53PM +0400, Vladislav Bolkhovitin wrote:
> +	unsigned int tgt_kobj_initialized:1;

It's the middle of the merge window, and I'm about to go on vacation, so
I didn't read this patch after this line.

It's obvious that this patch is wrong, you shouldn't need to worry about
this.  And even if you did, you don't need this flag.

Why are you trying to do something that no one else needs?  Why make
things harder than they have to be.

{sigh}

greg k-h
