From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: lots and lots of disks again
Date: Thu, 12 Feb 2004 15:57:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
References: <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4303 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266270AbUBLP5X
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 10:57:23 -0500
Content-Disposition: inline
In-Reply-To: <20040212150035.GN1780@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Andrew Morton <akpm@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com

On Thu, Feb 12, 2004 at 04:00:35PM +0100, Kurt Garloff wrote:
> Let's just use
>   31     20 19       4 3    0
>  |--major--|---disk---|-part-|
> 
> Any problems with that?

What the hell is "major"?  Device numbers space is flat - you don't even
need any sort of alignment for allocated chunks...
