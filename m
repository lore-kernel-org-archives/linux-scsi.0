From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI breaks 'make allyesconfig'
Date: Wed, 17 Nov 2004 14:05:59 +0000
Message-ID: <20041117140559.GM26623@parcelfarce.linux.theplanet.co.uk>
References: <419B5292.7080305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:6885 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262326AbUKQOGA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 09:06:00 -0500
Content-Disposition: inline
In-Reply-To: <419B5292.7080305@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Nov 17, 2004 at 08:30:58AM -0500, Jeff Garzik wrote:
> drivers/scsi/osst.o(.bss+0x0): In function `exit_osst':
> drivers/scsi/osst.c:195: multiple definition of `ST_partstat'
> drivers/scsi/st.o(.bss+0x0):drivers/scsi/st.c:244: first defined here

Reported yesterday, and the patch was sent to linux-scsi.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
