From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] SCSI ncr53c8xx.c: make a variable static
Date: Tue, 16 Nov 2004 02:34:04 +0000
Message-ID: <20041116023404.GD26623@parcelfarce.linux.theplanet.co.uk>
References: <20041115021612.GR2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:13465 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261748AbUKPCeF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 21:34:05 -0500
Content-Disposition: inline
In-Reply-To: <20041115021612.GR2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 15, 2004 at 03:16:12AM +0100, Adrian Bunk wrote:
> The patch below makes a needlessly global variable static.

This needs to be taken care of as part of a module_param conversion.
Something similar to the sym2 conversion, I think ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
