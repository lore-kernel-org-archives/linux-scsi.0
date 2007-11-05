From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Drivers accessors latest version
Date: Mon, 05 Nov 2007 11:09:29 +0200
Message-ID: <472EDDC9.6020109@panasas.com>
References: <47276EB9.7070603@panasas.com> <1194118892.4230.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32071 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753451AbXKEJJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 04:09:33 -0500
In-Reply-To: <1194118892.4230.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Nov 03 2007 at 21:41 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> This one has a clear merge bug:
> 
> index 2597209..bc63349 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> <snip> 
> So could you fix it up correctly, please (and just email the patch, I
> think it's the only problem commit).
> 
> Thanks,
> 
> James
> 

Sorry about that. I saw it and fixed it in git tree, (rebase),
anticipating a branch pull. But since you had to cherry-pick them 
by number you fetched the older patches. There is also a fix needed 
for wd7000.c, the one you have will not compile.

I will send both patches as reply to this mail.

Again sorry
Boaz
