From: Matthew Wilcox <willy@debian.org>
Subject: Re: coding style question
Date: Wed, 25 Feb 2004 18:25:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225182523.GD25779@parcelfarce.linux.theplanet.co.uk>
References: <c1ioqg$6ae$1@dent.deepthot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:28605 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261512AbUBYSZ3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 13:25:29 -0500
Content-Disposition: inline
In-Reply-To: <c1ioqg$6ae$1@dent.deepthot.org>
List-Id: linux-scsi@vger.kernel.org
To: Jay Denebeim <denebeim@deepthot.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 25, 2004 at 06:16:48PM +0000, Jay Denebeim wrote:
> I've noticed that in 2.6 many of the constructs like:
> 
> typedef struct foo { blah }
> 
> have been changed to 
> 
> struct foo { blah }
> 
> what was the reasoning for this?

We hate typedefs.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
