From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Tue, 24 Feb 2004 17:09:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224170906.GQ25779@parcelfarce.linux.theplanet.co.uk>
References: <40396134.6030906@realitydiluted.com> <20040222190047.01f6f024.akpm@osdl.org> <40396E8F.4050307@realitydiluted.com> <20040224061130.GC503530@sgi.com> <403B8108.6080606@realitydiluted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33726 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262308AbUBXRJI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:09:08 -0500
Content-Disposition: inline
In-Reply-To: <403B8108.6080606@realitydiluted.com>
List-Id: linux-scsi@vger.kernel.org
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 24, 2004 at 11:51:20AM -0500, Steven J. Hill wrote:
> +/*
> + * Device node mappings are as follows:
> + *
> + *    sr0 - first CDROM, whole disk
> + *    sr1 - first CDROM, first partition
> + *
> + *    [...]
> + *
> + *    sr16 - first CDROM, sixteenth partition
> + *    sr17 - second CDROM, whole disk
> + *    sr18 - second CDROM, first partition

Umm... no.  I suspect you mean:

sr15 - first CDROM, fifteenth partition
sr16 - second CDROM, whole disk
sr17 - second CDROM, first partition

But what a bad idea for device names.  Why not

sr0 whole disc
sr0a ... sr0o partitions
sr1, sr1a ... sr1o

It's probably too late to be consistent with discs and call them
sra, sra1, ... sra15
srb, srb1, ... srb15

> + *    [...]
> + */
> +static int partitions = 16;

15.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
