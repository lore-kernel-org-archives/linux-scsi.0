From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Replace semaphore with completion
Date: Thu, 21 Oct 2004 12:11:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021111137.GB16153@parcelfarce.linux.theplanet.co.uk>
References: <1098300699.20821.68.camel@thomas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36832 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270673AbUJULLo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 07:11:44 -0400
Content-Disposition: inline
In-Reply-To: <1098300699.20821.68.camel@thomas>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, Oct 20, 2004 at 09:31:39PM +0200, Thomas Gleixner wrote:
> 
> Use completion instead of semaphore

OK, I've taken this into my tree.  It'll be part of the 2.1.18m release.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
