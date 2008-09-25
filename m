From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 21:50:50 -0700
Message-ID: <20080925045050.GB4310@kroah.com>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D20@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYIYEvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 00:51:39 -0400
Content-Disposition: inline
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F27D20@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

On Wed, Sep 24, 2008 at 09:09:57PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains document of brocade specific sysfs interface. It is
> created using 2.6.27-rc7 kernel.

A lot of these (like the statistics) look like they should be debugfs
entries instead of sysfs.  Why do they need to be sysfs files, who/what
is going to use these entries?

thanks,

greg k-h
