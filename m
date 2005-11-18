From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: channel busy
Date: Fri, 18 Nov 2005 12:05:17 -0500
Message-ID: <437E09CD.4090602@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276BA4@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:27334 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964820AbVKRRFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 12:05:20 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276BA4@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> True - and we've been dancing around target busy as well.  Basically,
> if there's an HCIL, any component of the HCIL could potentially be busy.
> And, stirring the pot, there could be different queuing/resource limits
> at each point as well.

Agreed.

	Jeff



