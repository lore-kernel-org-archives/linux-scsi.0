From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: hpsa static checker issues
Date: Fri, 19 Jun 2015 10:46:08 +0300
Message-ID: <20150619074608.GM28762@mwanda>
References: <07F70BBF6832E34FA1C923241E8833AB486B33CF@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <07F70BBF6832E34FA1C923241E8833AB486B33CF@BBYEXM01.pmc-sierra.internal>
Sender: kernel-janitors-owner@vger.kernel.org
To: Don Brace <Don.Brace@pmcs.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, dl Team ESD Storage Dev Support <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 18, 2015 at 06:42:14PM +0000, Don Brace wrote:
> Dan,
> 
> You had noted three concerns covering: mutex_unlock, decode sense data, and a goto label issue, that were detected during
> your static checker run. 
> 
> I have patches that address these issues. 
> 
> I am thinking that I need to post these three patches linux-scsi.
> 
> Is that correct?

Yes.  That's right.

regards,
dan carpenter

