From: David Miller <davem@davemloft.net>
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Date: Tue, 15 Apr 2008 00:39:10 -0700 (PDT)
Message-ID: <20080415.003910.50277238.davem@davemloft.net>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080414141956.GN6695@cs181133002.pp.htv.fi>
Sender: sparclinux-owner@vger.kernel.org
To: bunk@kernel.org
Cc: aacraid@adaptec.com, James.Bottomley@HansenPartnership.com, wli@holomorphy.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 14 Apr 2008 17:19:56 +0300

> This patch fixes the following build error exposed by commit 
> 3a0086a80ab7c2f1adb0e9b2a6fc82632979cec5:

Please provide the commit header text as well as the ID when referring
to commits, because when backported to stable trees the ID might
be different.

I've fixed this up for you.

> <--  snip  -->
> 
>   MODPOST 1741 modules
> ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
