From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add missing $(obj) to aic7xxx makefile
Date: Wed, 14 Nov 2007 13:36:42 -0700
Message-ID: <20071114203642.GA17785@parisc-linux.org>
References: <1193398273.8993.8.camel@grianne> <20071114203046.GA10669@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49300 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760800AbXKNUgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 15:36:43 -0500
Content-Disposition: inline
In-Reply-To: <20071114203046.GA10669@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Nov 14, 2007 at 09:30:46PM +0100, Sam Ravnborg wrote:
> I had to modify the patch to make it actually work
> reliable with "make drivers/scsi/ -j".
> I have applied the below to kbuild.git.
> 
> linux-scsi cc'ed - please let me know if you prefer
> to take it via scsi tree.

It seems independent of anything else that might come out of the scsi
list.  Please take it via the kbuild tree.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
