From: Tore Anderson <tore@linpro.no>
Subject: Re: Disabling dev_loss_tmo?
Date: Tue, 13 Nov 2007 12:07:48 +0100
Message-ID: <47398584.6010407@linpro.no>
References: <47396A5B.5040001@linpro.no> <OF50F972F5.7F1838AD-ONC1257392.0038C0B2-C1257392.003926A2@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:45299 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXKMLH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 06:07:56 -0500
In-Reply-To: <OF50F972F5.7F1838AD-ONC1257392.0038C0B2-C1257392.003926A2@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Loehr <MLOEHR@de.ibm.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@sgi.com, hch@infradead.org, James.Smart@Emulex.Com

* Michael Loehr

> in recent SLES10 kernels the additional setting "remove_on_dev_loss" allows
> to control, if the devices are removed or not. Unfortunately this change
> did not find its way upstream yet ...

Thanks for pointing this out.  I found that this patch was submitted
here over a year ago, but unfortunately was rejected:

http://www.spinics.net/lists/linux-scsi/msg10289.html (I'm adding Cc's
to the folks that posted to that thread)

Christoph, would you be inclined to reconsider your position on this
patch if it was changed so that the default behaviour would still be to
remove devices after dev_loss_tmo expired?

The current behaviour is causing troubles because of intermittent rport
unavailability and the subsequent remove/readd actions way more often
than I am permanently removing targets from my SAN, so for me being able
to disable the automatic device removal would be a huge improvement for
me (and I doubt I'm the only one that feels this way).

Regards
-- 
Tore Anderson
