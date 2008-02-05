From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.24 regression w/ QLA2300
Date: Tue, 5 Feb 2008 08:22:10 -0800
Message-ID: <20080205162210.GH19882@plap3.qlogic.org>
References: <47A88736.6090706@hp.com> <20080205160246.GF19882@plap3.qlogic.org> <20080205161501.GG19882@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6547 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbYBEQWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 11:22:13 -0500
Content-Disposition: inline
In-Reply-To: <20080205161501.GG19882@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Seokmann Ju <seokmann.ju@qlogic.com>

On Tue, 05 Feb 2008, Andrew Vasquez wrote:

> > Could you load the (default 2.6.24) driver with
> > ql2xextended_error_logging modules parameter set:
> > 
> > 	# insmod qla2xxx ql2xextended_error_logging=1
> > 
> > and send the resultant kernel logs?
> 
> Could you tray the patch referenced here:
> 
> qla2xxx: Correct issue where incorrect init-fw mailbox command was used on non-NPIV capable ISPs.
> http://article.gmane.org/gmane.linux.scsi/38240


BTW:  the regression in question is not present in vanilla 2.6.24.
Instead it was introduced early on in the 2.6.25 merge-window.  Linus'
tree currently has the patch referenced above as well.

--
av
