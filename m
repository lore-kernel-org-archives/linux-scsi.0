From: Mark Lord <liml@rtr.ca>
Subject: Re: DMA mapping on SCSI device?
Date: Wed, 30 Jan 2008 12:00:58 -0500
Message-ID: <47A0AD4A.20109@rtr.ca>
References: <896139.88121.qm@web31812.mail.mud.yahoo.com> <479FDA52.8050204@shaw.ca> <47A0AC33.1060504@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:3361 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYA3RA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 12:00:59 -0500
In-Reply-To: <47A0AC33.1060504@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: ltuikov@yahoo.com, linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> ..
> Commands which were not ADMA compatible (eg. MODE_SENSE, 
> TEST_UNIT_READY, ..)
> were simply handled with PIO (in the driver) rather than any form of DMA,
> which is okay because those commands are relatively infrequent.
..

A slight correction there:  TEST_UNIT_READY was fine in ADMA mode as well.

Cheers
