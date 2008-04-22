From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptbase Code={Abort} (LSI SAS1068 PCI-X Fusion-MPT)
Date: Tue, 22 Apr 2008 14:02:52 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FFED91@NAMAIL2.ad.lsil.com>
References: <480E3C6D.5090604@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58471 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYDVUC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 16:02:57 -0400
Content-class: urn:content-classes:message
In-Reply-To: <480E3C6D.5090604@sauce.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org
Cc: sebastian@wasilewski.name

On Tuesday, April 22, 2008 1:29 PM,  Richard Scobie wrote:
> I received a reply from LSI:
> 
> "It seems there is some bad cable or connectivity or bad device in the
> topology. The loginfo 0x31123000 says the I/O is aborted due 
> to a Stuck
> Link. The loginfo 0x31120403 specifies the I/O is aborted due to frame
> transfer errors."
> 
> So far doing large dd reads and writes, I have been unable to 
> generate 
> any of these errors, it is only during the initial md RAID5 
> sync up, so 
> I guess this is going to be a little tricky to pin down.
> 

The loginfo bits are defined in a header inside the linux kernel
sources.  

Location:  /usr/src/linux/drivers/message/fusion/lsi/mpi_log_sas.h

If you search for 3000, you will find
PL_LOGINFO_CODE_WRONG_REL_OFF_OR_FRAME_LENGTH.

There's no match for 403, so I guess this iz a new define not included
in my version of the headers.

Eric
