From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.19.2] SCSI sd:  udev accessing an uninitialized
	scsi_disk results in a crash
Date: Fri, 02 Feb 2007 21:14:36 -0600
Message-ID: <1170472476.3380.55.camel@mulgrave.il.steeleye.com>
References: <200702021734.57161.nagendra_tomar@adaptec.com>
	 <20070202171924.a225cff7.akpm@linux-foundation.org>
	 <20070203015635.GA18467@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38504 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946302AbXBCDOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 22:14:50 -0500
In-Reply-To: <20070203015635.GA18467@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, Nagendra Singh Tomar <nagendra_tomar@adaptec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2007-02-02 at 17:56 -0800, Greg KH wrote:
> > Thanks - I'll queue this up for 2.6.20 also.
> 
> No objection from me, as long as James says this is ok.
> 
> I wonder why we haven't noticed this in the past?

Because the race is so small ...

I'll queue it in the rc-fixes tree .. I have three others for 2.6.20

James


