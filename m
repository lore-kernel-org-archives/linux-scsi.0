From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: RE: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: Wed, 09 Apr 2003 14:27:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <239330000.1049920048@aslan.btc.adaptec.com>
References: <A5974D8E5F98D511BB910002A50A66470580D766@hdsmsx103.hd.intel.com> <1049919802.16880.84.camel@astrognat>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:6862 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263775AbTDIUQg (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 16:16:36 -0400
In-Reply-To: <1049919802.16880.84.camel@astrognat>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>, "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: Rohit Gupta <rohit@davsys.com>, linux-scsi@vger.kernel.org

> On Wed, 2003-04-09 at 20:26, Cress, Andrew R wrote:
> 
> AC> What version of the aic79xx driver is in that kernel?
> AC> I hope it is >= 1.3.1?
> 
> It's 1.3.0.  I'll see if I can find and build a later one.  I take it
> there is a known serious bug in <1.3.1, then?

The latest driver is 1.3.6:

http://people.FreeBSD.org/~gibbs/linux/SRC/
http://people.FreeBSD.org/~gibbs/linux/DUD/aic79xx/
http://people.FreeBSD.org/~gibbs/linux/RPM/aic79xx/

There have been several bugs fixed since 1.3.0.  See the CHANGELOG file
in the source distributions for details.  Depending on the drives you are
using, you may also need to run with a fairly low tag depth (32 is the
default we use in our binary distributions) to get the drivers stable.

--
Justin

