From: Mark Overmeer <Mark@Overmeer.net>
Subject: Re: Adaptec 2810SA problems
Date: Sat, 26 Jun 2004 13:23:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040626132327.B31119@speeltuin.ATComputing.nl>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D40D@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from speeltuin.ATComputing.nl ([195.108.229.26]:11024 "EHLO
	speeltuin.ATComputing.nl") by vger.kernel.org with ESMTP
	id S266256AbUFZLae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jun 2004 07:30:34 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D40D@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Jun 25, 2004 at 08:59:06AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

* Salyzyn, Mark (mark_salyzyn@adaptec.com) [040625 14:52]:
> Your best bet to hone in on the problem is to contact Adaptec Technical
> support, make sure you have your products TSID handy.

I will try that, (but usually as last resort)

> The appears dead message is a result of a failure in the adapter
> identified by performing a sequence of health checks. Finer resolution
> of this failure mode is available in the Adaptec release for this
> driver.

Is there a 2.6.7 driver of Adaptec itself?  I thought they only had their
own 2.4.* versions...

> The card's firmware can be updated by using the native Linux cli tool
> supplied with the card.

It's not in the description of the driver software.  That always worries
me a little....  The docs are rather unsatisfactory...
-- 
Thanks for the answer,

               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net
