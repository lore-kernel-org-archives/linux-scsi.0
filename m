From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] drivers/scsi/sym53c8xx_2/sym_hipd.c: make a function static
Date: Tue, 1 Mar 2005 02:47:21 +0000
Message-ID: <20050301024721.GD28741@parcelfarce.linux.theplanet.co.uk>
References: <20050228220155.GS4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:24271 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261218AbVCACrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 21:47:25 -0500
Content-Disposition: inline
In-Reply-To: <20050228220155.GS4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: matthew@wil.cx, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 28, 2005 at 11:01:55PM +0100, Adrian Bunk wrote:
> This patch makes a needlessly global function static.

Thanks, committed

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
