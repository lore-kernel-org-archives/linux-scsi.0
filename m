From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 15:04:01 -0400
Message-ID: <4304DBA1.4050900@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:14297 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932400AbVHRTE0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 15:04:26 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
>>What we might need an rport for is to support SMP.  I'm
>>not yet sure how to do SMP passthrough, but we will need some object
>>to represent SMP ports.
> 
> 
> Depending on how SATA support is implemented, it may be useful for that.


You can already see how SATA support is implemented ;-)

We just need to wrap it in a transport class.

	Jeff


