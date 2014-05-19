From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
Date: Tue, 20 May 2014 02:46:23 +0300
Message-ID: <20140519234623.GA17724@mwanda>
References: <1400474832-22422-1-git-send-email-Julia.Lawall@lip6.fr>
 <F5D084D6342F9B479C34599BB0A03E4D01284E742E@AVMB1.qlogic.org>
 <20140519201202.GA15585@mwanda>
 <alpine.DEB.2.10.1405200735210.3003@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405200735210.3003@hadrien>
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 20, 2014 at 07:36:48AM +0800, Julia Lawall wrote:
> 
> 
> On Mon, 19 May 2014, Dan Carpenter wrote:
> 
> > On Mon, May 19, 2014 at 04:07:52PM +0000, Saurav Kashyap wrote:
> > > Hi Julia,
> > >
> > > Status is already set to 0 at the beginning of the function, I think
> > > we should just "return status" here to be consistent with the rest of
> > > the function.
> >
> > "return 0;" is more clear than "return status;".
> >
> > Consistency is great so long as it makes the code easier to read.  Don't
> > lose track of the real goal.
> 
> If status were an informative word, there might be a reason for it.  But
> integer typed functions almost always return their status, so there is no
> real information.

Just to be clear, I'm agreeing with you...  "return 0;" is better.

regards,
dan carpenter

