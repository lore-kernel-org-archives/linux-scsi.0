From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 11:12:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4055D5E8.9010105@pobox.com>
References: <20040314082444.GA3416@linux.local.home>	<1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de>	<1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme>	<1079278279.2022.34.camel@mulgrave> <20040314154713.GH19737@krispykreme> 	<20040314204158.GB1463@havoc.gtf.org> <1079303231.2848.69.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16873 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262680AbUCOQMj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 11:12:39 -0500
In-Reply-To: <1079303231.2848.69.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> We already do all of that, if you look ...
[...]
> We do this too.
[...]

Oh, no argument.  I use some of that stuff in libata, too.

These are features, however are not specific to SCSI.  They are just 
thin wrappers on top of the block layer, and would be more generally 
useful one layer up...  :)

	Jeff



