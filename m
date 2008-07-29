From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 12:55:13 -0600
Message-ID: <20080729185512.GE24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729192126.7261318b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37899 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYG2SzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 14:55:14 -0400
Content-Disposition: inline
In-Reply-To: <20080729192126.7261318b@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>

On Tue, Jul 29, 2008 at 07:21:26PM +0100, Alan Cox wrote:
> Also early SD type devices with 256 byte sectors simply don't work with
> our scsi midlayer.

Are any of them still spinning, or did the lubricant leak out a couple
of decades ago?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
