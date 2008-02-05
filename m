From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: aic7xxx build failure
Date: Tue, 5 Feb 2008 10:37:00 -0800
Message-ID: <20080205103700.63b658f2@laptopd505.fenrus.org>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
	<1202235484.3133.49.camel@localhost.localdomain>
	<20080205182441.GF505@cs181133002.pp.htv.fi>
	<1202236256.3133.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbYBESh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 13:37:27 -0500
In-Reply-To: <1202236256.3133.52.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 05 Feb 2008 12:30:56 -0600

> > make: *** [sub-make] Error 2
> 
> Do I assume from this that you have different source and object
> directories?  There shouldn't be a failure if this is building
> in /home/bunk/linux/kernel-2.6/git/linux-2.6/ because the source file
> should be there.
> 
> James

time to run a fsck as well just to rule stuff out?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
