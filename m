From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: what to do with dpt_i2o
Date: Mon, 11 Oct 2004 10:30:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416A448E.7080405@shadowconnect.com>
References: <20040925134622.GA19871@lst.de> <20041009150114.GA21229@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0003.shadowconnect.net ([213.239.201.226]:61877 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S267994AbUJKI0T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 04:26:19 -0400
In-Reply-To: <20041009150114.GA21229@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mark_Salyzyn@adaptec.com, linux-scsi@vger.kernel.org

Hello,

Christoph Hellwig wrote:
>>Marcus, you'd been doing a lot of testing with the DPT/Adaptec cards for
>>the new i2o layer, right?  IIRC we now have both support for the Adaptec
>>managment utils and the optimizes sglist format, so there's probably no
>>reason anymore to keep dpt_i2o.

Maybe i should list some remaining issues:

- 64 bit Scatter Gather elements
- supports hot-changing of devices, and array changes without a reboot.

The second one is implemented, but didn't work on my system. I didn't 
have the time to verify if the dpt_i2o driver recognize it if a drive fails.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
