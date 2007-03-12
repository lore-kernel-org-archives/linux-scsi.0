From: Douglas Gilbert <dougg@torque.net>
Subject: Re: How to send inquiry command to thorugh sd path (i.e. /dev/sda)
 by using SG_IO ioctl
Date: Mon, 12 Mar 2007 11:28:39 -0400
Message-ID: <45F571A7.5010609@torque.net>
References: <982174.32681.qm@web32912.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60549 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030407AbXCLP2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 11:28:47 -0400
In-Reply-To: <982174.32681.qm@web32912.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dudekula mastan <d_mastan@yahoo.com>
Cc: linux-scsi@vger.kernel.org

dudekula mastan wrote:
> Hi Gilbert,
>    
>   Thanks for quick reply.
>    
>   The example program (sg_Simple --- not only this all examples) is taking /dev/sg  path as input  but I want /dev/sd path as input.

In the lk 2.6 series, it will also work for "sd" devices
(and "hd" devices if they happen to be cd/dvd drives).

>   Please explain me with an example, which takes /dev/sd path as input.

You have one already. Actually you have lots of examples there.

>    Is SG_IO supports sd driver ? 

yes, in the lk 2.6 series.

 I am not sure.. I think it will work only for sg driver. Am I correct ?.

That was correct several years ago, not now.

Doug Gilbert
