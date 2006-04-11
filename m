From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] 3ware 9000 disable local irqs during kmap_atomic
Date: Tue, 11 Apr 2006 15:25:27 -0400
Message-ID: <443C02A7.5020407@garzik.org>
References: <b1bc6a000604111125s74a95319m39e23598ed4755a5@mail.gmail.com>	 <443BFB37.8080400@garzik.org> <b1bc6a000604111212i1fe8e057j1857fc9a512d3363@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40586 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751079AbWDKTZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 15:25:32 -0400
In-Reply-To: <b1bc6a000604111212i1fe8e057j1857fc9a512d3363@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

adam radford wrote:
> On 4/11/06, Jeff Garzik <jeff@garzik.org> wrote:
>> I saw the fix go into 2.6.17-rc1-git on git-commits-head list.  Please
>> check out the latest linux-2.6.git and send a patch against what's in
>> there...
>>
>>         Jeff
>>
> 
> Jeff,
> 
> The patch in 2.6.17-rc1-git5 is for the 3w-xxxx driver, which is fine.
> The patch I sent is the same fix for the 3w-9xxx driver.

Ah!  Ignore me, then :)

	Jeff



