From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit
Date: Thu, 6 Oct 2011 17:30:38 +0300
Message-ID: <20111006143038.GC18470@longonot.mountain>
References: <20111005055046.GD32077@elgon.mountain>
 <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
 <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Achim Leubner <Achim_Leubner@pmc-sierra.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 05, 2011 at 05:19:12AM -0700, Achim Leubner wrote:
> Looks good so far. But do we really need the last two lines?
> > +	if (len > 16)
> > +		len = 16;
> 

snprintf() returns the number of characters that it _would_ have
copied if it had space.  We want to return the number of bytes
actually copied.

Again, the snprintf() values do fit so this change doesn't actually
make any difference.

regards,
dan carpenter
