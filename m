From: Matthew Wilcox <willy@debian.org>
Subject: Re: Signed-off-by: added    [Re: [PATCH]: Flexible timeout infrastructure]
Date: Tue, 15 Jun 2004 16:24:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615152406.GI20511@parcelfarce.linux.theplanet.co.uk>
References: <40CF0F9F.4050902@adaptec.com> <40CF1104.30903@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7613 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261605AbUFOPYH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:24:07 -0400
Content-Disposition: inline
In-Reply-To: <40CF1104.30903@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 11:08:52AM -0400, Luben Tuikov wrote:
> Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>
> 
> ===== drivers/scsi/scsi.c 1.143 vs edited =====
> --- 1.143/drivers/scsi/scsi.c	2004-04-28 12:32:09 -04:00
> +++ edited/drivers/scsi/scsi.c	2004-06-14 15:13:12 -04:00
> @@ -549,7 +549,12 @@
> 		host->resetting = 0;
> 	}
> 
> -	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
> +	/* If the LLDD claims to be able to handle its own command timeout,
> +	 * don't start the timer.  It will start it before sending the 
> command

Your patches have been brokenly linewrapped by your email system.
Of course, this wouldn't matter if you weren't suffering from ia64-itis.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
