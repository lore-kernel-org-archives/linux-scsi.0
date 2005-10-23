From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC] use struct scsi_lun in generic code
Date: Sun, 23 Oct 2005 03:01:38 -0400
Message-ID: <435B3552.1010205@pobox.com>
References: <20051023043301.GA22615@havoc.gtf.org> <435B1E0E.8060409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:1473 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751418AbVJWHBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 03:01:47 -0400
In-Reply-To: <435B1E0E.8060409@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> With 8 byte luns, max_lun is legacy. I found it a nuisance
> when I played with wluns (well known lus). Looks like
> you may be coping with that.

See the patch I just posted...


> If you want to decode SAM-4 luns, perhaps for verbose
> error purposes, feel free to borrow code from the
> attached sg_luns (which is slightly more up to date
> than the one found in sg3_utils version 1.17).

If you're bored, feel free to contribute a better version of 
scsilun_to_str()...   ;-)

	Jeff


