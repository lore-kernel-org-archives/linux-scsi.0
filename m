From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] sym2 2.1.18i
Date: Fri, 12 Mar 2004 19:51:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040312195108.GY2148@parcelfarce.linux.theplanet.co.uk>
References: <20040312193923.GX2148@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:60587 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262432AbUCLTvJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 14:51:09 -0500
Content-Disposition: inline
In-Reply-To: <20040312193923.GX2148@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 12, 2004 at 07:39:23PM +0000, Matthew Wilcox wrote:
> 
>  - Correct a typo "mvram" -> "nvram".
>  - Re-do the PQS/PDS support which I'd #if 0 out.  Should even work on
>    multiple-domain boxes now ;-)
>  - Move all the nvram definitions to sym_nvram.h (from Gerard's 2.1.19-pre3)
>  - hcb_p -> struct sym_hcb *
>  - sdev_p -> struct sym_device *
>  - Delete a lot of unused macros from sym_misc.h
>  - Move READ_BARRIER and WRITE_BARRIER definitions to sym_glue.h
>  - SYM_CONF_NVRAM_WRITE_SUPPORT (from Gerard's 2.1.19-pre3).  Not enabled
>    yet.
>  - Fix some -W warnings (some courtesy of Adrian Bunk).

I know there's 2 patches from Christoph and a patch from Mike that
aren't in this release.  This version's been sitting in the -pa tree for
a couple of month and I wanted to get it out before adding more changes.
I'm adding those patches to the -pa tree now and I'll do another release
after 2.4.5.  Everybody happy?  No, me neither.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
