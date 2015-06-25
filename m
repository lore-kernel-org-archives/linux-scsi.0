From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] SCSI-wd33c93: Deletion of a check before the function
 call "wd33c93_setup"
Date: Thu, 25 Jun 2015 12:55:00 +0300
Message-ID: <20150625095500.GZ28762@mwanda>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <558ACDDE.5090403@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <558ACDDE.5090403@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "James E. J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 24, 2015 at 05:33:50PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 24 Jun 2015 17:15:17 +0200
> 
> The wd33c93_setup() function performs also input parameter validation.
> Thus the test around the call is not needed.
> 

Guys, you should be aware that Markus auto generates his patches and he
doesn't even do a cursory review.

"I find it acceptable that some of my update suggestions do not fit
to your quality expectations at the moment." -- Markus Elfring
(https://lkml.org/lkml/2015/1/22/446)

regards,
dan carpenter

