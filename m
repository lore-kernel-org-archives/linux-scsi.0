From: Matthew Wilcox <willy@debian.org>
Subject: Re: syslog message
Date: Mon, 30 Aug 2004 18:48:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040830174808.GK16196@parcelfarce.linux.theplanet.co.uk>
References: <200408301716.i7UHGagO008392@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22716 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268707AbUH3RsO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 13:48:14 -0400
Content-Disposition: inline
In-Reply-To: <200408301716.i7UHGagO008392@bach.leonora.org>
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 30, 2004 at 10:16:36AM -0700, Vladimir G. Ivanovic wrote:
>    kernel: Badness in sym_complete_error at drivers/scsi/sym53c8xx_2/sym_hipd.c:5513

That line is:
                MDELAY(100);
which becomes:
		mdelay(100)
which is defined as:
	({unsigned long __ms=(n); while (__ms--) udelay(1000);})

Why this causes badness ...

> I have a ASUS CUV4X-DLS motherboard (2xPIII) running Fedora Core 2
> kernel (2.6.8-1.525smp)

You'd have to ask Fedora.  No doubt they have some patch that causes it.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
