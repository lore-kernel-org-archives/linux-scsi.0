From: Bernd Schubert <bs@q-leap.de>
Subject: Re: need help with sg ioctls
Date: Tue, 4 Mar 2008 12:08:02 +0100
Message-ID: <200803041208.02448.bs@q-leap.de>
References: <200802281743.51332.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:46942 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYCDLIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 06:08:04 -0500
In-Reply-To: <200802281743.51332.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Thursday 28 February 2008 17:43:51 Bernd Schubert wrote:
> Hello,
>
> for some reasons the kernel.org qla4xxx driver doesn't work for us. Version
> 5.01.00.08 seems to work a bit better, but all default sg-ioctl's are not
> defined.
>
> Adding these manually as in scsi/sg.c works, but IMHO is rather stupid. Is
> there a sane way to call sg_ioctl()?
> I mean it's static and also not exported and the file_operations ioctl
> method is already taken by the qla4xxx driver.
>
> Do I miss something?

Enventually we found the reason for all the trouble. It was a bug in one of 
the debian udev scripts (scsi_devfs.sh), which made it to override /dev 
entries with wrong device major/minors (debian bug Bug#468939).

Sorry for the noise.




-- 
Bernd Schubert
Q-Leap Networks GmbH
