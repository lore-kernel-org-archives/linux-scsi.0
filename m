From: Tejun Heo <tj@kernel.org>
Subject: Re: Use-after-free in ata_qc_issue
Date: Mon, 23 Sep 2013 09:43:49 -0400
Message-ID: <20130923134349.GJ30946@htj.dyndns.org>
References: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
 <20130922163913.GE28571@htj.dyndns.org>
 <CACT4Y+aGOzEdGZ_rnJ_52hWCph-nyDhd1ukKW=8M0QNSyR0WpA@mail.gmail.com>
 <CACT4Y+bKPWkiLJEC2tk076TmPcYcXb_BuKiSG9H2BoWnOZJuiQ@mail.gmail.com>
 <20130922214733.GB27616@mtj.dyndns.org>
 <CACT4Y+ZBZ8fbGWtQpvdievrZ2-ecxCN-=8V6-rRm_+86eEd+XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:62835 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3IWNnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 09:43:53 -0400
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZBZ8fbGWtQpvdievrZ2-ecxCN-=8V6-rRm_+86eEd+XA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-ide@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>, Marc C <marc.ceeeee@gmail.com>, aaron.lu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>

Hello,

On Sun, Sep 22, 2013 at 02:51:51PM -0700, Dmitry Vyukov wrote:
> > Yeah, could be.  IIRC, there's still race condition in block / scsi
> > timeout handling.  Hmmm...
> 
> Is there an open bug for this?

Not that I know of.  ISTR a couple threads about it.  My memory is
quite hazy as usual but IIRC there's a race window between arming the
timer and the command issue path actually becoming ready for timer
going off and I wouldn't be suprised if there are other race
conditions around timeout / exception handling path.  It kinda has
grown over time and I don't think anybody audited how the whole thing
fits and works together. :(

Thanks.

-- 
tejun
