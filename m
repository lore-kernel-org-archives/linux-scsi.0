From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: 26 Jan 2004 10:45:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075135509.2290.46.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D2F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:27602 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264444AbUAZQpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 11:45:16 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703D19D2F@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

On Mon, 2004-01-26 at 10:37, Moore, Eric Dean wrote:
> Here is another update for the MPT Fusion drivers.

Thanks.

> * added CONFIG_LBA, READ16, WRITE16 support

I'd like to see this routine to determine direction go away in favour of
just using the direction the mid layer sends down.  However, this isn't
a blocking item, I'll try and get this update into early 2.6.2

James


