From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: Wed, 13 Oct 2004 15:04:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041013140439.GI16153@parcelfarce.linux.theplanet.co.uk>
References: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com> <416D3536.5030501@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63429 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269709AbUJMOEk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 10:04:40 -0400
Content-Disposition: inline
In-Reply-To: <416D3536.5030501@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Oct 13, 2004 at 09:01:26AM -0500, Brian King wrote:
> grow_buffers(struct block_device *bdev, sector_t block, int size)
> {
>         struct page *page;
>         pgoff_t index;
>         int sizebits;
> 
>         /* Size must be multiple of hard sectorsize */
>         if (size & (bdev_hardsect_size(bdev)-1))
>                 BUG();
>         if (size < 512 || size > PAGE_SIZE)
>                 BUG();                      <----- line 1271 is here

What tree is this in?  Neither of these BUG()s appear in 2.6.9-rc4.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
