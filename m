From: sandip shete <sandipshete@gmail.com>
Subject: Re: How to send inquiry command to thorugh sd path (i.e. /dev/sda)
 by using SG_IO ioctl
Date: Fri, 8 Jun 2007 00:18:15 -0700 (PDT)
Message-ID: <11021647.post@talk.nabble.com>
References: <9429164.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:58747 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968261AbXFHHlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 03:41:09 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1HwYjf-00009x-1d
	for linux-scsi@vger.kernel.org; Fri, 08 Jun 2007 00:18:15 -0700
In-Reply-To: <9429164.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


download sg_utils3 and use the sg_inq command to do so


MasthanUsha wrote:
> 
> 
> Hi All,
>  
> Any one og you have any idea on scsi inquiry command ?
>  
> I want to send an Inquiry command to a scsi device through sd path (.i.e.
> /dev/sda or /dev/sdb) by using SG_IO ioctl. Please explain me...
>  
>  
> Your help is appreciated
>  
> Regards
> Masthan
>  
> 
> 

-- 
View this message in context: http://www.nabble.com/How-to-send-inquiry-command-to-thorugh-sd-path-%28i.e.--dev-sda%29-by-using-SG_IO-ioctl-tf3387437.html#a11021647
Sent from the linux-scsi mailing list archive at Nabble.com.

