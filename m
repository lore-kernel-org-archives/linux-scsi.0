From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] tmscsim: improve tagging
Date: Tue, 19 Oct 2004 14:10:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041019131051.GN16153@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.60.0410190011090.6761@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52455 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269366AbUJSNKx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 09:10:53 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0410190011090.6761@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Oct 19, 2004 at 12:55:51AM +0200, Guennadi Liakhovetski wrote:
> Reviews as well as suggestions for (stress-)testing of task-queueing paths 
> welcome. Until now I never saw tags higher than 0 on tmscsim:-) However, 
> it could have been due to debugging.

> @@ -2292,10 +2285,10 @@
>  	.queuecommand		= DC390_queuecommand,
>  	.eh_abort_handler	= DC390_abort,
>  	.eh_bus_reset_handler	= DC390_bus_reset,
> -	.can_queue		= 42,
> +	.can_queue		= 1,
>  	.this_id		= 7,
>  	.sg_tablesize		= SG_ALL,
> -	.cmd_per_lun		= 16,
> +	.cmd_per_lun		= 1,
>  	.use_clustering		= DISABLE_CLUSTERING,
>  };
>  

Isn't cmd_per_lun set to only use one tag with this patch?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
