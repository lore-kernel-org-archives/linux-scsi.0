From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 09/11] drivers/scsi/sym53c8xx_2/*: convert to pci_register_driver
Date: Mon, 7 Mar 2005 00:35:15 +0000
Message-ID: <20050307003515.GX28741@parcelfarce.linux.theplanet.co.uk>
References: <20050306222717.C0F441F205@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:62864 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261578AbVCGAfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 19:35:18 -0500
Content-Disposition: inline
In-Reply-To: <20050306222717.C0F441F205@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, c.lucas@ifrance.com

On Sun, Mar 06, 2005 at 11:27:17PM +0100, domen@coderock.org wrote:
> convert from pci_module_init to pci_register_driver
> (from:http://kerneljanitors.org/TODO).

Already applied to the sym2 driver in my tree, thanks.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
