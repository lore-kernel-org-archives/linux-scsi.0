From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Mon, 24 Jan 2005 14:22:45 +0000
Message-ID: <20050124142245.GJ31455@parcelfarce.linux.theplanet.co.uk>
References: <20050124094629.GA9404@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46528 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261514AbVAXOWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 09:22:47 -0500
Content-Disposition: inline
In-Reply-To: <20050124094629.GA9404@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, Jan 24, 2005 at 10:46:29AM +0100, Heiko Carstens wrote:
> @@ -1099,9 +1099,9 @@
>  }
>  
>  void
> -zfcp_dummy_release(struct device *dev)
> +zfcp_generic_services_release(struct device *dev)
>  {
> -	return;
> +	kfree(dev);
>  }
>  
>  /*

I thought that having release methods that just called kfree() were
also verboten?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
