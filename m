From: Willy Tarreau <willy@w.ods.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into the kernel
Date: Sat, 1 Oct 2005 06:58:13 +0200
Message-ID: <20051001045812.GF18716@alpha.home.local>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com> <433D8D1F.1030005@adaptec.com> <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com> <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com> <433DD020.8000906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750733AbVJAFEq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <433DD020.8000906@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Kyle Moffett <mrmacman_g4@mac.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2005 at 07:54:08PM -0400, Jeff Garzik wrote:
> Greg Freemyer wrote:
> >Luben has more than once called for adding a small number of
> >additional calls to the existing SCSI core.  These calls would
> >implement the new (reduced) functionallity.  The old calls would
> >continue to support the full SPI functionallity.  No existing  LLDD
> >would need modification.
> 
> IOW, what Luben wants is:
> 
> 	if (Luben)
> 		do this
> 	else
> 		do current stuff
> 
> If this is the case, why bother touching drivers/scsi/* at all?

that's the reason why I proposed that this moved to drivers/sas/* or
somewhere else so that there is no maintaining conflict.

Regards,
Willy
