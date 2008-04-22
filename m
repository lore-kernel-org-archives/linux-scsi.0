From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mptbase Code={Abort} (LSI SAS1068 PCI-X Fusion-MPT)
Date: Wed, 23 Apr 2008 08:16:02 +1200
Message-ID: <480E4782.3020109@sauce.co.nz>
References: <0631C836DBF79F42B5A60C8C8D4E8229FFED91@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:56476 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYDVUN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 16:13:29 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229FFED91@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, sebastian@wasilewski.name

Moore, Eric wrote:

> The loginfo bits are defined in a header inside the linux kernel
> sources.  
> 
> Location:  /usr/src/linux/drivers/message/fusion/lsi/mpi_log_sas.h
> 
> If you search for 3000, you will find
> PL_LOGINFO_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH.
> 
> There's no match for 403, so I guess this iz a new define not included
> in my version of the headers.
> 
> Eric

Thanks Eric. I doubt I can source a new backplane to swap out, so I'll 
try to find out if there is a more recent firmware for it and try that.

Regards,

Richard
