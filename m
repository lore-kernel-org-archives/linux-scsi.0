From: Matthew Wilcox <willy@debian.org>
Subject: Re: two SCSI HBAs having same host no in Linux 2.4 kernel
Date: Wed, 17 Mar 2004 14:46:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317144619.GG25059@parcelfarce.linux.theplanet.co.uk>
References: <200403171940.23006.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45956 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261524AbUCQOqU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 09:46:20 -0500
Content-Disposition: inline
In-Reply-To: <200403171940.23006.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: SCSI -DEVELOPERS <linux-scsi@vger.kernel.org>

On Wed, Mar 17, 2004 at 07:40:23PM +0530, N.C.Krishna Murthy wrote:
> In case of drivers which do not support new_eh_code, 'detect' is called
> without any locks. Is this SMP safe? 

... why aren't you using the new_eh_code?

I suspect the answer is that this is part of the transition; that old
drivers were expected to have their own lock inside ->detect and new
ones don't.  But I wasn't around for that, so I'm not sure.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
