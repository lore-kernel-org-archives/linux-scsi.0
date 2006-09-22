From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: 64bit DMA in i2o_block
Date: Fri, 22 Sep 2006 13:47:56 +0200
Message-ID: <4513CD6C.9050606@shadowconnect.com>
References: <4513A87F.8040809@sw.ru> <4513B783.70008@shadowconnect.com> <p73lkoci32y.fsf@verdi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0006.shadowconnect.net ([213.202.216.60]:4879 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S932308AbWIVLr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 07:47:58 -0400
In-Reply-To: <p73lkoci32y.fsf@verdi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, devel@openvz.org

Hello,

Andi Kleen wrote:
> Markus Lidel <Markus.Lidel@shadowconnect.com> writes:
>> I believe it's a driver issue. Do you have a testing-system where you
>> could try out the appended patch?
> So it would bug instead? 

Yes, because ATM i don't know why it doesn't work. It's just for debugging.

> Can you please just get rid of that CONFIG? Such things shouldn't 
> be CONFIGs, but have a suitable default. In particular drivers
> running under 64bit should always support 64bit DMA.

The 64-bit DMA is only available on Adaptec controllers, all other I2O 
controllers only work with 32-bit DMA. Although the 64-bit DMA is (as far 
as i can remember) slower then the 32-bit DMA and is therefore only 
useful on systems which run out of memory.


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
