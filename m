From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
Date: Tue, 30 Dec 2008 13:16:12 -0600
Message-ID: <1230664572.18627.2.camel@localhost.localdomain>
References: <49593940.9060102@cybernetics.com>
	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41636 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbYL3TQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 14:16:15 -0500
In-Reply-To: <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Tue, 2008-12-30 at 12:10 +0200, Aaro Koskinen wrote:
> Thanks. The updated patch is below.

Tony,

Since we're lacking an active maintainer on this one and you seem
interested, could you run these patches through your tests to make sure
they're reasonably OK and then respond with an ack?

Thanks,

James


