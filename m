From: Lan <transter@gmail.com>
Subject: Adjusting scsi_cmnd timeout_per_command value?
Date: Fri, 19 Nov 2004 11:50:07 -0800
Message-ID: <ac71172a0411191150329d6e39@mail.gmail.com>
Reply-To: Lan <transter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.204]:12701 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261557AbUKSTuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 14:50:14 -0500
Received: by rproxy.gmail.com with SMTP id 34so113956rns
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 11:50:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Is it possible to control the timeout value of scsi commands that are
submitted to a particular device from an upper layer driver? I figured
I'd have to either change the scsi_device's timeout value or the
request's timeout value. Given that I'm relying on the block layer's
__make_request function to build a request, is there a safe way to
adjust the timeout value for a  scsi_device from the upper layer? Or
is there a better way to do this, i.e. something similar to how
sg_timeout is associated with a request_queue and can subsequently be
used to set timeout values for sg_io's?  Or maybe a scsi device
timeout value should be under the control of the LLDs only?


Thanks!!
lan
