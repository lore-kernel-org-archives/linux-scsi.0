From: Kenneth Porter <shiva@sewingwitch.com>
Subject: Re: legacy megaraid status
Date: Wed, 21 Sep 2005 09:10:05 -0700
Message-ID: <30E6DB5A16C820CE29D97507@[10.169.6.233]>
References: <433175AE.5070905@darthvader.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:34237 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S1751101AbVIUQKZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 12:10:25 -0400
Received: from home.sewingwitch.com (c-67-160-222-127.hsd1.ca.comcast.net [67.160.222.127])
	(authenticated bits=0)
	by segw.microprecisionautomation.com (8.13.1/8.13.1) with ESMTP id j8LGA47j029351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 09:10:10 -0700
Received: from [10.169.6.233] (segw.microprecisionautomation.com [69.17.55.168])
	(authenticated bits=0)
	by home.sewingwitch.com (8.13.1/8.13.1) with ESMTP id j8LGA0FO017251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 09:10:03 -0700
In-Reply-To: <433175AE.5070905@darthvader.us>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--On Wednesday, September 21, 2005 4:01 PM +0100 Yiannis Mavroukakis 
<jander@darthvader.us> wrote:

> What is the current situation with the legacy megaraid driver? It seems
> that is is broken for a lot
> of people with old raid cards.

Any particular card you're interested in?

I've got a test kernel built based on Fedora Core 4's installation kernel 
to try the new driver with the old i4-100 (ATA100 RAID) but haven't had a 
chance to build a boot disk with it so I can test it on my working Fedora 
Core 2 server. (Gotta re-learn how to make boot media. Haven't done that 
since I made a boot floppy with Red Hat 6.)
