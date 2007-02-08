From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: program inquiry is using a deprecated scsi_ioctl , please
	convert it to SG_IO
Date: Thu, 08 Feb 2007 09:50:55 -0500
Message-ID: <1170946255.3766.18.camel@mulgrave.il.steeleye.com>
References: <8862659.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41680 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422758AbXBHOu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 09:50:57 -0500
In-Reply-To: <8862659.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Masthan <d.mastan@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-02-08 at 02:14 -0800, Masthan wrote:
> I am not getting why i am getting the following DIAG message
> 
> Program inquiry is using deprecated scsi ioctl, please convert it to SG_IO.
> 
> The following snippet of linux source code clearly saying that, the above
> message is a kind of cosmetic warning message.
> 
> Do you know how to use SG_IO to overcome this problem.
> 
> The following function sayign that only 6 scsi ioctls are deprecated, out of
> 6 inquiry program is using  only 2 scsi ioctls(i.e.SCSI_IOCTL_SEND_COMMAND
> and SCSI_IOCTL_TEST_UNIT_READY ) . What are their equivalents SG_IO ioctls ?

Yes, see, e.g.

http://www.linux.org/docs/ldp/howto/SCSI-Generic-HOWTO/sg_io.html

although SG_IO can be sent to any SCSI device, not just sg.

James


