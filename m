From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Thu, 5 Sep 2002 02:39:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10209050239.ZM52086@classic.engr.sgi.com>
References: <200209041613.g84GDtv02639@localhost.localdomain>
	<12750000.1031158209@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
        "Re: aic7xxx sets CDR offline, how to reset?" (Sep  4, 10:50am)
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sep 4, 10:50am, Justin T. Gibbs wrote:
> 
>    This of course assumes that all transactions have a serial number and
>    that requeuing transactions orders them by serial number.  With QErr
>    set, the device closes the rest if the barrier race for you, but even
>    without barriers, full transaction ordering is required if you don't
>    want a read to inadvertantly pass a write to the same location during
>    recovery.


The original FCP (SCSI commands over Fibre) profile specified that QERR=1
was not available.  Unless that is changed, it would appear that you cannot
count on being able to set Qerr.

Qerr was one of those annoying little things in SCSI that forces host
adapter drivers to know a mode page setting.

jeremy
