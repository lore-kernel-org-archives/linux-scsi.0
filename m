From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: Bad fibre channel performance: need howto
Date: Mon, 24 Nov 2003 12:30:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069673445.1231.18.camel@cala>
References: <1069443458.7047.35.camel@cala>  <3FC1E393.4090907@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp4.tin.it ([212.216.176.224]:53890 "EHLO vsmtp4.tin.it")
	by vger.kernel.org with ESMTP id S263745AbTKXLaz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 06:30:55 -0500
In-Reply-To: <3FC1E393.4090907@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

Il lun, 2003-11-24 alle 11:55, Fabien Salvi ha scritto:

> Hello Mario,
> 


> If you want, I can send you an archive of the howto.
> I've downloaded it a long time ago, before sistina removed it from their 
> server.
> 
> But, it's true, it's a bit old

Yes send it to me please. I like to read all.

> About your problem, I am not sure it's really because of FibreChannel.
> There are a lot of differences between theorical values and real ones.
> Which tool are you using for the benchmark ?

I know but usually the "sequential read" is the easiest test to discover
if there are problems.

I have used hdparm and sg3 tools to do a quick sequential read test.
On ide world if hdparm tells me that I have  sequential transfer rate
lower than shown on web reviews it means that I have to tweak dma, etc.
and usually after tweaking I get performance promised.

Here there is little to tweak and I then discovered with a serious test
(tiobench) that write performance is also worse.

I suppose there is some problem.

I am now buying a qlogic2200 to try if it is better.
Can someone tell me best drivers for qlogic2200?


Thanks again!


-- 
Mario Giammarco


