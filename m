From: Vasily Averin <vvs@sw.ru>
Subject: Re: 64bit DMA in i2o_block
Date: Fri, 22 Sep 2006 15:39:53 +0400
Message-ID: <4513CB89.9010101@sw.ru>
References: <4513A87F.8040809@sw.ru> <4513B783.70008@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:35263 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S932295AbWIVLkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 07:40:05 -0400
In-Reply-To: <4513B783.70008@shadowconnect.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-scsi@vger.kernel.org, devel@openvz.org

Markus Lidel wrote:
> Hello,
> 
> Vasily Averin wrote:
>> I've found that your driver does not work correctly with following
>> options:
>> CONFIG_I2O_EXT_ADAPTEC=y
>> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
>> I've checked it on 2.6.18 kernel on x86_64 node with 4Gb memory.
> 
> I believe it's a driver issue. Do you have a testing-system where you
> could try out the appended patch?

Done. troubles are present, BUG_ON did not trigger.

thank you,
	Vasily Averin
