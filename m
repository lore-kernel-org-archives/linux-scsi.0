From: Leon Toh <tltoh@attglobal.net>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Wed, 02 Jun 2004 18:11:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6.1.1.1.2.20040602101949.031112f0@mail.optusnet.com.au>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com>
 <20040601152020.GA6706@lst.de>
 <20040601152357.GA6928@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail013.syd.optusnet.com.au ([211.29.132.67]:57984 "EHLO
	mail013.syd.optusnet.com.au") by vger.kernel.org with ESMTP
	id S265213AbUFBILb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 04:11:31 -0400
In-Reply-To: <20040601152357.GA6928@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com


>>  Two showstoppers though:
>>
>>   - the spin_is_locked magic is really, really bogus.  Easiest way to
>>     avoid this is to have your own spinlock in adpt_hba and use
>>     scsi_assign_lock to make it the host_lock, too.  With a little
>>     magic you'll also get per-host locks in the various 2.4 vendor
>>     trees with that..
>>   - you're still trying to sneak DPT_TARGET_BUSY back in.
>>
>>  Please fix those two issues and the patch can go in.
>
>Ah, and one more:  README.dpti is misplaced in drivers/scsi/, it should
>update Documentation/scsi/dpti.txt instead.

Is there a placement recommendation of driver README files in 2.4 than ?  

