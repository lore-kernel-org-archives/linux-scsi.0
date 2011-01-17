From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove duplicate include of
	target/target_core_device.h from drivers/target/target_core_hba.c
Date: Mon, 17 Jan 2011 14:43:05 -0800
Message-ID: <1295304185.22813.247.camel@haakon2.linux-iscsi.org>
References: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net>
	 <1295302951.22813.227.camel@haakon2.linux-iscsi.org>
	 <alpine.LNX.2.00.1101172326060.27021@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101172326060.27021@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 23:26 +0100, Jesper Juhl wrote:
> On Mon, 17 Jan 2011, Nicholas A. Bellinger wrote:
> 
> > On Mon, 2011-01-17 at 22:46 +0100, Jesper Juhl wrote:
> > > drivers/target/target_core_hba.c includes target/target_core_device.h 
> > > twice - the two includes are even on two lines next to each other.
> > > This patch removes the duplicate include.
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > 
> > Committed as:
> > 
> > [linus-38-rc1 95f39d1] target: remove duplicate include target_core_device.h
> > 
> > Please let me know if you have more include cleanups so they can be git
> > squashed'  into a single commit for scsi-post-merge-2.6.git/for-jejb.
> > 
> I only found that one so far...
> 

<nod>  So for minor stuff like this (especially when the merge window is
winding down) feel tree to send this to me directly and CC linux-scsi
and I will make sure this gets in via scsi-post-merge-2.6.git/for-jejb.

--nab
