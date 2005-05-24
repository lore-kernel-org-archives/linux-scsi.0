From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 03:10:52 -0400
Message-ID: <4292D37C.5020700@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:15309 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261375AbVEXHK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:10:57 -0400
In-Reply-To: <20050524070714.GU9855@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Jens Axboe wrote:
> On Tue, May 24 2005, Jeff Garzik wrote:
>>I can describe how this will look when libata is divorced from SCSI, if 
>>you would like, too...
> 
> I was beginning to dispair you had given up that plan...

hehe, nope.  I promised Linus, and I plan to keep my promise :)

I know how to do it.  Internally things have been kept as separate as 
possible from the SCSI layer.

Bart even hinted at possibly using libata-without-SCSI for future 
/dev/hdX support.  It's certainly doable.

	Jeff



