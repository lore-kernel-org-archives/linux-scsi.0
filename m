From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Tue, 28 Oct 2003 08:29:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028082903.A9789@beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com> <1067031185.4772.48.camel@persist.az.mvista.com> <20031027091655.B4263@vienna.EGENERA.COM> <20031027072733.A20720@beaverton.ibm.com> <20031027120631.E4263@vienna.EGENERA.COM> <20031027093116.A21595@beaverton.ibm.com> <20031028091920.J4263@vienna.EGENERA.COM> <20031028070640.A8503@beaverton.ibm.com> <20031028104054.K4263@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:11749 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264014AbTJ1QaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 11:30:09 -0500
Content-Disposition: inline
In-Reply-To: <20031028104054.K4263@vienna.EGENERA.COM>; from pauld@egenera.com on Tue, Oct 28, 2003 at 10:40:54AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Tue, Oct 28, 2003 at 10:40:54AM -0500, Philip R. Auld wrote:

> Does udev need to care about multi-pathing? I'm not sure that it does - it doesn't 
> do multi-pathing, it just makes device nodes, right?

Right.

> It seems that if we want the underlying paths to show up as separate named devices 
> we would need to use an ID key that is different from the one that the multipath 
> detection code uses so that we do get the underlying paths. That's why I 
> suggested the below. 


> Do md/dm devices get created by udev? Then the problem shows up again. 
> We'd get the md device named "disk-1" as well :)

They are on different busses, so udev should (but does not now) use the
bus plus the callout value to figure out the name. This is needed
independent of scsi (though only a scsi callout exists today).

-- Patrick Mansfield
