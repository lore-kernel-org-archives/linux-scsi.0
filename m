From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 3/5] scsi disk: report size without overflow
Date: Fri, 28 Oct 2005 15:09:17 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0510281508160.31903@shark.he.net>
References: <200510282207.j9SM7XvR022280@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:11679 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030263AbVJ1WJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:09:20 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 15:09:17 -0700
In-Reply-To: <200510282207.j9SM7XvR022280@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rdunlap@xenotime.net

On Fri, 28 Oct 2005 akpm@osdl.org wrote:

>
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> With CONFIG_LBD=n, 'sz' (32 bits) can overflow when capacity is multiplied
> (even * 2), as seen in a report from Dale Blount on lkml.  Also make sure
> that 'mb' will not overflow.
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
>
>  drivers/scsi/sd.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)

James has a version that doesn't require 64-bit operations
(when CONFIG_LBD=n, on x86-32) that he prefers, I believe.

-- 
~Randy
