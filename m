From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] fix for Incorrect number of segments after building	list
 problem
Date: Wed, 20 Oct 2004 13:45:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4176A448.5040508@pobox.com>
References: <1097790683.1717.47.camel@mulgrave>	<20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de>	<1098287481.2008.6.camel@mulgrave>  <20041020155825.GP10531@suse.de> <1098288465.2008.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8580 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268831AbUJTRqB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 13:46:01 -0400
In-Reply-To: <1098288465.2008.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> slight problem is testing.  Only SATA and IDE have this short descriptor
> problem, so I've nothing really to test the actual fix with.


Clearly we need to remedy this :)

	Jeff


