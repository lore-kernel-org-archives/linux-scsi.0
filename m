From: Douglas Gilbert <dougg@torque.net>
Subject: Re: How to send inquiry command to thorugh sd path (i.e. /dev/sda)
 by using SG_IO ioctl
Date: Mon, 12 Mar 2007 08:54:38 -0400
Message-ID: <45F54D8E.9040902@torque.net>
References: <9429164.post@talk.nabble.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965766AbXCLMyp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 08:54:45 -0400
In-Reply-To: <9429164.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MasthanUsha <d_mastan@yahoo.com>
Cc: linux-scsi@vger.kernel.org

MasthanUsha wrote:
> 
> Hi All,
>  
> Any one og you have any idea on scsi inquiry command ?
>  
> I want to send an Inquiry command to a scsi device through sd path (.i.e.
> /dev/sda or /dev/sdb) by using SG_IO ioctl. Please explain me...

If you look at http://www.torque.net/sg/sg3_utils.html
and fetch a tarball (e.g. sg3_utils-1.23.tgz) then have
a look at the examples/sg_simple1.c file.

Doug Gilbert

