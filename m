From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 13:58:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF07E8A316.708939F4-ON88256F35.0072E805-88256F35.0073320E@us.ibm.com>
References: <1098469018.19463.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:47338 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267549AbUJVU75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 16:59:57 -0400
In-Reply-To: <1098469018.19463.26.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Mark Lord <lsml@rtr.ca>

>-EINVAL: "I recognize this ioctl but the arguments are bogus"
>-ENOTTY: "I don't recognize this ioctl at all"

You mean of course "this ioctl command code."

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
