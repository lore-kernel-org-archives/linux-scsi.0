From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH] scsi: fix documentation of scsi_mod.scan defaults
Date: Mon, 29 Jun 2009 19:32:20 +0200
Message-ID: <878wjbhrob.fsf@tac.ki.iif.hu>
References: <87ws70m8yw.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:36763 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZF2Rc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2009 13:32:26 -0400
Received: from wferi by tac.ki.iif.hu with local (Exim 4.69)
	(envelope-from <wferi@niif.hu>)
	id 1MLKiK-00052Z-Mj
	for linux-scsi@vger.kernel.org; Mon, 29 Jun 2009 19:32:20 +0200
In-Reply-To: <87ws70m8yw.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Thu,
	25 Jun 2009 21:03:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Signed-off-by: Ferenc Wagner <wferi@niif.hu>
> ---
>  Documentation/kernel-parameters.txt |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 92e1ab8..848035b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2144,10 +2144,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  			S390-tools package, available for download at
>  			http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html
>  
> -	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
> -			discovered.  async scans them in kernel threads,
> -			allowing boot to proceed.  none ignores them, expecting
> -			user space to do the scan.
> +	scsi_mod.scan=	[SCSI] sync scans SCSI busses as they are discovered.
> +			async scans them in kernel threads, allowing boot to
> +			proceed.  none ignores them, expecting user space to
> +			do the scan.  Default is async if CONFIG_SCSI_SCAN_ASYNC
> +			is defined, sync otherwise.
>  
>  	security=	[SECURITY] Choose a security module to enable at boot.
>  			If this boot parameter is not specified, only the first
> -- 
> 1.5.6.5

Hi,

Please somebody educate me...  Why are my two documentation patches
(this and and other in <87pre3ixyy.fsf@tac.ki.iif.hu> from 20 May)
ignored?  Am I totally off the map?
-- 
Thanks,
Feri.
