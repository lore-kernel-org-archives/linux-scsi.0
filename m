From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6 tape device i/o error
Date: Thu, 10 Jun 2004 23:31:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040610223119.GI24864@parcelfarce.linux.theplanet.co.uk>
References: <1048.65.172.177.78.1086906305.squirrel@65.172.177.78>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47799 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263162AbUFJWbU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 18:31:20 -0400
Content-Disposition: inline
In-Reply-To: <1048.65.172.177.78.1086906305.squirrel@65.172.177.78>
List-Id: linux-scsi@vger.kernel.org
To: kbass@kenbass.com
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 10, 2004 at 06:25:05PM -0400, kbass@kenbass.com wrote:
> Under 2.4 I have code the does:
> fd = open("/dev/st0", RDONLY)
> This always returns success.
> 
> Under this new 2.6.4 (SMP) (plus alot of other changes) this same device
> open hangs for 1-2 minutes and returns I/O error IF THERE IS NO TAPE in
> the drive. If a tape is present, no problem.

Try adding O_NONBLOCK.  Just a guess.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
