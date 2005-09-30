From: Fawad Lateef <fawadlateef@gmail.com>
Subject: Re: Re: accessing the scsi disk from a kernel module
Date: Fri, 30 Sep 2005 12:56:06 +0500
Message-ID: <1e62d13705093000563a95972d@mail.gmail.com>
References: <433CCCD2.3000003@cdac.in>
	 <1e62d137050929230019fcbfb6@mail.gmail.com> <433CE0EB.6040803@cdac.in>
Reply-To: Fawad Lateef <fawadlateef@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.207]:4418 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030236AbVI3H4H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 03:56:07 -0400
Received: by wproxy.gmail.com with SMTP id i2so188207wra
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2005 00:56:06 -0700 (PDT)
In-Reply-To: <433CE0EB.6040803@cdac.in>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthik Sarangan <karthiks@cdac.in>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On 9/30/05, Karthik Sarangan <karthiks@cdac.in> wrote:
> I dont want the buffer cache of the block device interfering.
>
> Basically I require to read/write data (without being cached or copied into
> intermediate kernel buffers) to scsi disk from a kernel module.
>
> Hope this make my meaning clearer.
>

Ya, I havn't did thing what you want but for sending SCSI Commands to
the SCSI Device directly you have to use SCSI Protocol, in
Kernel-2.6.x I found generic SCSI Mid-Layer Driver
(http://lxr.linux.no/source/drivers/scsi/scsi.c) and other files with
name scsi_* in drivers/scsi/ from which you can get help and also look
header files defined in include/scsi/ which actually has the
structures holding the SCSI cmnds etc ......  (CMIIW)


--
Fawad Lateef
