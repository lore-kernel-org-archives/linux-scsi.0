From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 14:11:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928131151.GV16153@parcelfarce.linux.theplanet.co.uk>
References: <4159611C.4030106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:27607 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267777AbUI1NL4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:11:56 -0400
Content-Disposition: inline
In-Reply-To: <4159611C.4030106@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28, 2004 at 09:03:24AM -0400, Luben Tuikov wrote:
> config SCSI_AIC79XX
> 	tristate "Adaptec AIC79xx U320 support"
> -	depends on PCI && SCSI
> +	depends on PCI

Wrong.  This allows modular SCSI and non-modular AIC79xx.  That's just daft
and can't possibly work.  Put the depend back.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
