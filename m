From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 05 Apr 2004 12:37:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40713706.9000308@shadowconnect.com>
References: <40712A47.4090903@shadowconnect.com> <20040405111843.B4077@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:18090 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261795AbUDEKga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 06:36:30 -0400
In-Reply-To: <20040405111843.B4077@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hello,

Christoph Hellwig wrote:
> Please separate gratious reformating from the actual patch.

Okay, no problem.

>>+	#define REPLY_FRAME_SIZE (17)
>>+	#define SG_TABLESIZE (30)
> Well, for a kernel submission I'd suggest to move them where they belong.

Okay...

>>+        c=i2o_find_controller(cmd->iop);
>>+	if(c == NULL)
>>+                return -ENXIO;
> Codingstyle looks rather strange here and in a few other places.
> Should be more like:
> 	c = i2o_find_controller(cmd->iop);
> 	if (!c)
> 		return -ENXIO;

that's right, i only copied it over from dpt_i2o, and tried to make it 
work with i2o_config, but haven't looked at coding style at all :-(

>>+	get_user(reply_size, &user_reply[0]);
> You need to check the return value here.

Okay...

> Could you also please try to work out all the 64bit issues first?

Yes, i'll try to get it fixed. But maybe you know someone who could help 
me a little bit, because i'm a little bit stuck at the moment :-(

I know a little bit about the I2O stuff, but not much about the SCSI 
driver. Maybe if you have some time, you could look at:

http://marc.theaimsgroup.com/?l=linux-scsi&m=108085372527131&w=2

and give me a hint, where to begin searching. Also it would help, if you 
know someone who could help me further :-D

Thank you very much for your comments.


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
