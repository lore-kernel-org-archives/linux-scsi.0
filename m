From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Tue, 8 Mar 2005 23:38:52 -0800
Message-ID: <20050309073852.GE4525@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C12ED0C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:45259 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262208AbVCIHiV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 02:38:21 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12ED0C@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, linux-scsi@vger.kernel.org

On Wed, 09 Mar 2005, James.Smart@Emulex.Com wrote:

> 
> So, is there a reason we aren't just starting the workq thread
> upon the first call to queue something to it ?
> 

I don't see any reason why that approach wouldn't work in this
circumstance..

--
av
