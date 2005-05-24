From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 03:18:51 -0400
Message-ID: <4292D55B.3050801@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524070714.GU9855@suse.de> <4292D37C.5020700@pobox.com> <4292D44C.2040102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:19917 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261401AbVEXHS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:18:56 -0400
In-Reply-To: <4292D44C.2040102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Hannes Reinecke wrote:
> We've finally succeeded in convincing everyone that having '/dev/sdX'
> instead of '/dev/hdX' was a neccessary step forward.
> I think we're getting shot if we now tell them to reverse this _again_.
> Can we at least have it optional?

I will not break compatibility with /dev/sdX, don't worry :)

It will always be there as an optional piece, as I described in my other 
reply to you.

	Jeff


