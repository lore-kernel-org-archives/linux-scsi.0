From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: scsi: lpfc_scsi: Remove unused variables
Date: Thu, 7 Jun 2012 01:42:24 -0500
Message-ID: <20120607064224.GD3210@burratino>
References: <4FD0434B.7090405@gentoo.org>
 <20120607061255.GB3210@burratino>
 <4FD04854.5010304@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47679 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2FGGm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 02:42:28 -0400
Content-Disposition: inline
In-Reply-To: <4FD04854.5010304@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Yao <ryao@gentoo.org>
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

Richard Yao wrote:

> Using -Werror enables us to catch potential runtime issues before they
> happen.

You have more trust in GCC and other compilers than I do.

If you'd like some entertainment, then for example see:

 http://gcc.gnu.org/PR52798
 http://gcc.gnu.org/PR25509

Bugs and misdesigned features do not have to be involved for this to
be a problem --- all it takes is a gcc upgrade that adds a new
warning, and suddenly you've turned your existing potential code
cleanliness improvements into failed builds and lots of wasted time
for innocent sysadmins.  -Werror is great for development, but using
it in production turns out to be pretty much always a terrible idea.

Thanks for the chance to vent about this. :)  It's bad, bad, bad.

Ciao,
Jonathan
