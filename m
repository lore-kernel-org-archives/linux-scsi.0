From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: Tue, 28 Sep 2004 15:56:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928145638.GY16153@parcelfarce.linux.theplanet.co.uk>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38886 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267746AbUI1O4k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:56:40 -0400
Content-Disposition: inline
In-Reply-To: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2004 at 11:58:26PM +1000, Anton Blanchard wrote:
> Ive got a 2.6.9-rc2-bk tree from about September 16 which exploded in
> sym_prepare_nego. It turns out sdev is NULL, and scsi_device_dt(sdev)
> causes the trouble.
> 
> A few lines above there is a check for sdev != NULL, so assuming it is
> valid to be NULL add a check before scsi_device_dt() too.

Yes, this looks like the right solution to me.

Can you tell me what circumstances you see it under, and do you
successfully negotiate 160MB/s with this patch?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
