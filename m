From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Tue, 18 Oct 2005 17:06:24 -0400
Message-ID: <435563D0.7050502@pobox.com>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com> <435069E3.90306@torque.net> <43506AA3.3030502@pobox.com> <43507BA7.6090406@torque.net> <43507D5F.2050407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:53402 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932143AbVJRVG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 17:06:29 -0400
In-Reply-To: <43507D5F.2050407@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: dougg@torque.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, russb@emc.com

Tejun Heo wrote:
> $ cat ~/bin/git-sync.sh
> #!/bin/sh
> 
> if [ ! -r .git/origin ]; then
>         echo "not in git repo" 2>&1
>         exit 1
> fi
> 
> rsync -avz --ignore-existing $(cat .git/origin)/ .git/
> rsync -avz $(cat .git/origin)/refs/ .git/refs/
> 
>  After syncing, you need to do 'git-read-tree -m upstream' 
> 'git-checkout-cache -q -f -u -a'


In the fast-moving world of git, this is a bit outdated.  You should use

	git checkout -f upstream

to check out a specific branch.

	Jeff


