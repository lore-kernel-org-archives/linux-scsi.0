From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] target: remove duplicate include of target/target_core_device.h
 from drivers/target/target_core_hba.c
Date: Mon, 17 Jan 2011 23:26:29 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101172326060.27021@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net> <1295302951.22813.227.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19588 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1AQW02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 17:26:28 -0500
In-Reply-To: <1295302951.22813.227.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, 17 Jan 2011, Nicholas A. Bellinger wrote:

> On Mon, 2011-01-17 at 22:46 +0100, Jesper Juhl wrote:
> > drivers/target/target_core_hba.c includes target/target_core_device.h 
> > twice - the two includes are even on two lines next to each other.
> > This patch removes the duplicate include.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Committed as:
> 
> [linus-38-rc1 95f39d1] target: remove duplicate include target_core_device.h
> 
> Please let me know if you have more include cleanups so they can be git
> squashed'  into a single commit for scsi-post-merge-2.6.git/for-jejb.
> 
I only found that one so far...

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

