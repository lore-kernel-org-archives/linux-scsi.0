From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Mon, 21 Feb 2005 02:02:21 +0000
Message-ID: <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk>
References: <20050221010758.GC30800@colo.lackof.org> <4219355E.1000807@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:1463 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261197AbVBUCCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 21:02:25 -0500
Content-Disposition: inline
In-Reply-To: <4219355E.1000807@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, willy@parisc-linux.org, linux-scsi@vger.kernel.org

On Sun, Feb 20, 2005 at 08:11:58PM -0500, Jeff Garzik wrote:
> Patch doesn't apply with -p1.

Doesn't matter; I can cope with both.

> >--- drivers/scsi/sym53c8xx_2/sym_glue.c	20 Feb 2005 23:49:27 -0000 
> >1.84
> 
> This file does not include <linux/config.h>.

Doesn't need to -- sym_glue.h does.

> >--- drivers/scsi/sym53c8xx_2/sym_hipd.c	16 Feb 2005 20:54:02 -0000 
> >1.48
> 
> ditto

ditto.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
