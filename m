From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx compile failure
Date: Tue, 20 May 2003 15:52:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <18510000.1053467557@aslan.btc.adaptec.com>
References: <1053467040.3784.6.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:48772 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261193AbTETVjc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 17:39:32 -0400
In-Reply-To: <1053467040.3784.6.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: wli@holomorphy.com, Stian Jordet <liste@jordet.nu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Several people have reported compile failures due to this code in
> aic7xxx_osm.c:

Look at the latest drop from my site.  I removed this code last week,
but postponed releasing another driver drop until I could untangle the
mess in the 2.4.X tree.

http://people.FreeBSD.org/~gibbs/linux/SRC/

--
Justin

