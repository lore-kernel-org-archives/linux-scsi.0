From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [patch] [SCSI] aacraid: use lower snprintf() limit
Date: Tue, 11 Oct 2011 07:46:55 -0700
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D05E48085@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <20111005055046.GD32077@elgon.mountain> <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de> <FD2BDBE06AC58549AE9E16C08B45675D05D8ED9E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20111006143038.GC18470@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20111006143038.GC18470@longonot.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Agreed.

Thanks,
Achim

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Donnerstag, 6. Oktober 2011 16:31
To: Achim Leubner
Cc: Rolf Eike Beer; Adaptec OEM Raid Solutions; James E.J. Bottomley;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit

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
