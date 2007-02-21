From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: program inquiry is using a deprecated scsi_ioctl , please
	convert it to SG_IO
Date: Wed, 21 Feb 2007 11:17:47 -0600
Message-ID: <1172078268.3335.29.camel@mulgrave.il.steeleye.com>
References: <8862659.post@talk.nabble.com>
	 <1170946255.3766.18.camel@mulgrave.il.steeleye.com>
	 <868c9d9d0702202233pa206222jb9beb85d60089003@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57839 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422712AbXBURRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 12:17:50 -0500
In-Reply-To: <868c9d9d0702202233pa206222jb9beb85d60089003@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MASTHAN DUDEKULA <d.mastan@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

If you want help, please don't drop linux-scsi.

On Wed, 2007-02-21 at 12:03 +0530, MASTHAN DUDEKULA wrote:
> Thanks for your reply.
>  
> I have one question to you.
> Can you please answetr this one ?
> What is SG_IO equivalent of SCSI_IOCTL_SCSI_COMMAND on sd devices ?
>  
> In otherwords How can we send SCSI_IOCTL_SCSI_COMMAND through SG_IO 
> ioctls.

SG_IO is an ioctl which is capable of sending a SCSI command similar to
the SCSI_IOCTL_SCSI_COMMAND ioctl.
 
James


