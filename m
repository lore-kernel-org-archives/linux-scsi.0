From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH 2.4] sym53c8xx_2 sniff inquiry fix
Date: Mon, 5 Apr 2004 16:35:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405153543.GW16469@parcelfarce.linux.theplanet.co.uk>
References: <04Apr5.112407edt.332198@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10452 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262794AbUDEPfp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 11:35:45 -0400
Content-Disposition: inline
In-Reply-To: <04Apr5.112407edt.332198@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: willy@debian.org, linux-scsi@vger.kernel.org

On Mon, Apr 05, 2004 at 11:24:13AM -0400, Tony Battersby wrote:
> The following patch fixes a problem where sym53c8xx_2 always sniffs a
> value of 0x00 for inquiry byte 56, which breaks 160 MB/s negotiations.
> 
> I am working with lk 2.4.x; I don't know if this needs to be applied to
> lk 2.6.x also.

2.6 already has this fix; I only maintain 2.6 -- the 2.4 sym drivers
are unmaintained.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
