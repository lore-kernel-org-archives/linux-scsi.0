From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 07:35:08 -0700
Message-ID: <20051123143508.GT1598@parisc-linux.org>
References: <20051123134327.GS1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54926 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750837AbVKWOfJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 09:35:09 -0500
Content-Disposition: inline
In-Reply-To: <20051123134327.GS1598@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsanchez@todounix.homeip.net
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 23, 2005 at 06:43:27AM -0700, Matthew Wilcox wrote:
> 2. Can you try a later kernel?  If you have git, you can pull from
>    git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
>    otherwise http://www.parisc-linux.org/~willy/sym2-2.2.2.diff applies
>    to a 2.6.15-rc1 kernel.

I also noticed that akpm put out 2.6.15-rc2-mm1 today which includes the
sym2 patches, so you could try that instead.
