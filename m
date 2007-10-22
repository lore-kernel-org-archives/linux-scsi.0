From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: LSIFC909 problem
Date: Mon, 22 Oct 2007 10:18:04 -0600
Message-ID: <20071022161804.GB27248@parisc-linux.org>
References: <1192952032.16384.11.camel@localhost> <664A4EBB07F29743873A87CF62C26D70A87BD8@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51861 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXJVQSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 12:18:06 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70A87BD8@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: egi <pfammatter-egi@swissonline.ch>, linux-scsi@vger.kernel.org, mdr@sgi.com, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Mon, Oct 22, 2007 at 10:11:24AM -0600, Moore, Eric wrote:
> Sorry for delayed repsonse, but the FC909 is not supported anymore.   I
> need to suppy a patch to remove this support.  Here is feedback from
> Micheal Reed.  About a two years ago the mptfc was rewrote to support
> the fibre channel transport layer.

Sounds like we need a new driver written to support the FC909 then.
Unless we could pretend the FC909 is a parallel scsi card or something
... that wasn't quite clear from Michael's mail.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
