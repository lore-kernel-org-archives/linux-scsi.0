From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: Tue, 16 Nov 2004 10:12:33 -0500
Message-ID: <419A18E1.4070207@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com> <41994CED.4080204@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61643 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261999AbUKPPMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 10:12:54 -0500
In-Reply-To: <41994CED.4080204@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Jeff Garzik wrote:
> 
> Overall, what is needed is 'host control', which can include device
> topology manipulation.
> 

Yes, I agree.

So would it be wise to conclude that an "extension" to the LLDD
methods would be needed.  I think this is what SDI would end up being.
Host/Bus/target/lun woulnd't merely be enough, albeit only in the
core of the OS.  HBTL translation is one of the points SDI addresses.

	Luben

