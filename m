From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Thu, 5 Sep 2002 17:32:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209051732.ZM53465@classic.engr.sgi.com>
References: <200209041613.g84GDtv02639@localhost.localdomain>
	<12750000.1031158209@aslan.btc.adaptec.com>
	<10209050239.ZM52086@classic.engr.sgi.com>
	<122900000.1031232923@aslan.scsiguy.com>
	<10209051656.ZM53302@classic.engr.sgi.com>
	<100360000.1031271224@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
        "Re: aic7xxx sets CDR offline, how to reset?" (Sep  5,  6:13pm)
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Sep 5,  6:13pm, Justin T. Gibbs wrote:
> 
> > But don't the controllers have to know which commands have been silently
> > aborted by the target?
> 
> The controller drivers would need to know that the QErr policy is in
> effect for a given device.

Right.  We're on the same page now.  So you'd need some interface for
the sd driver (or midlayer) to tell the host driver what the QErr policy
is for a given lun.  I don't recall seeing that in the current layer,
but it would be easy to add, presumably.

jeremY
