From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: dmx3191d scsi driver needed
Date: Tue, 12 Oct 2004 14:48:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012134804.GE16153@parcelfarce.linux.theplanet.co.uk>
References: <ckglad$lrl$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64224 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262418AbUJLNsE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 09:48:04 -0400
Content-Disposition: inline
In-Reply-To: <ckglad$lrl$1@sea.gmane.org>
List-Id: linux-scsi@vger.kernel.org
To: jamrock <news_jamrock@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2004 at 08:19:11AM -0500, jamrock wrote:
> I need a driver for the dmx3191d SCSI card.  The card came with a Umax
> scanner.
> 
> Is there a driver that someone can recommend?  I have seen results when I
> use Google, but I am wary of using code that is not from a trusted source.

config SCSI_DMX3191D
        tristate "DMX3191D SCSI support"
        depends on PCI && SCSI
        help
          This is support for Domex DMX3191D SCSI Host Adapters.

          To compile this driver as a module, choose M here: the
          module will be called dmx3191d.


-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
