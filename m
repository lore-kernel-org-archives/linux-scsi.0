From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: Mon, 20 Sep 2004 15:48:46 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414E6F3E.4070502@torque.net>
References: <1095526671.2483.5.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:27073 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S266048AbUITFtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 01:49:36 -0400
In-Reply-To: <1095526671.2483.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> The purpose of this patch is to allow a SCSI reset to be issued directly
> to the devices without having to go via sg.  Because the reset may be
> issued even while the device is in recovery, this had to be done via a
> new api (sd won't invoke scsi_ioctl() while the device is in recovery).

James,
Perhaps there should be a new reset called:
     ...RESET_LOGICAL_UNIT

as this is now defined as a task management function in SAM-3.
If so ...RESET_DEVICE might get a synonym: ...RESET_TARGET.
Most transports support a RESET_TARGET while RESET_BUS is
SPI specific (is there an FCP equivalent?).

Doug Gilbert
