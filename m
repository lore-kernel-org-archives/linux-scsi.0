From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 14:00:14 -0700
Message-ID: <20110523140014.8c15534b.rdunlap@xenotime.net>
References: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44042 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757529Ab1EWVAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2011 17:00:18 -0400
In-Reply-To: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, 23 May 2011 13:56:26 -0700 Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20be668..a831859 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6039,6 +6039,16 @@ F:	Documentation/accounting/taskstats*
>  F:	include/linux/taskstats*
>  F:	kernel/taskstats.c
>  

wrong place, TARGET < TASKSTATS, so it should be above here ^^^^^

otherwise, looks good.  Thanks.

> +TARGET SUBSYSTEM
> +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> +L:	linux-scsi@vger.kernel.org
> +L:	http://groups.google.com/group/linux-iscsi-target-dev
> +W:	http://www.linux-iscsi.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> +S:	Supported
> +F:	drivers/target/
> +F:	include/target/
> +
>  TC CLASSIFIER
>  M:	Jamal Hadi Salim <hadi@cyberus.ca>
>  L:	netdev@vger.kernel.org
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
