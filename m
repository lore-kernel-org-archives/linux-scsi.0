From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] convert eata to pass pointers around
Date: Tue, 2 Nov 2004 14:54:18 +0000
Message-ID: <20041102145418.GA24690@parcelfarce.linux.theplanet.co.uk>
References: <20041102143351.GA32020@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52876 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262113AbUKBOyT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 09:54:19 -0500
Content-Disposition: inline
In-Reply-To: <20041102143351.GA32020@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 03:33:51PM +0100, Christoph Hellwig wrote:
> @@ -836,7 +836,7 @@
>  	struct mssp sp;		/* Local copy of sp buffer */
>  };
>  
> -static struct Scsi_Host *sh[MAX_BOARDS + 1];
> +struct Scsi_Host *sh[MAX_BOARDS];
>  static const char *driver_name = "EATA";
>  static char sha[MAX_BOARDS];
>  static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;

Did you mean to un-static 'sh'?  This seems like an awfully vague
name to make kernel-global ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
