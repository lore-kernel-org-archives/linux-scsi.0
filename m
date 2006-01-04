From: Adrian Bunk <bunk@stusta.de>
Subject: drivers/scsi/pcmcia/aha152x_stub.c: variable used before set
Date: Wed, 4 Jan 2006 19:12:30 +0100
Message-ID: <20060104181230.GR3831@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39177 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1030257AbWADSMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2006 13:12:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This bug is still present in recent kernels.

cu
Arian


----- Forwarded message from d binderman <dcb314@hotmail.com> -----

Date: 	Tue, 28 Jun 2005 09:14:28 +0000
From: d binderman <dcb314@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: variable used before set

Hello there,

I just tried to compile the Linux Kernel version 2.6.11.12
with the most excellent Intel C compiler. It said

drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "tmp" is used 
before its value is set
       tmp.device->host = info->host;
       ^

This is clearly broken code, since the field tmp.device has not been
initialised, and so isn't pointing to anything.

Suggest code rework.


----- End forwarded message -----

