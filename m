From: "Amit D. Chaudhary" <amit_c@comcast.net>
Subject: Re: A question on low-level driver document
Date: Thu, 13 May 2004 18:18:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A41E5A.4060002@comcast.net>
References: <519672568F040C41B6FAC21ADF51B18FEFF1@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:24981 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S264184AbUENBU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 21:20:28 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFF1@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

Pick up a driver and follow the function pointers for 
Scsi_Host_Template. For example, qlogicfc.c,
static Scsi_Host_Template driver_template = QLOGICFC;
qlogicfc.h for definition of QLOGICFC.

The detect fptr is good starting point.

Amit


Lee Xing wrote:
> Hi,
> 
> I could find <<SCSI mid_level - lower_lever driver interface>> for Linux kernel 2.6.  Is there a similar document for Linux 2.4?  The interface between mid_level and lower_level has quite a few changes from lk 2.4 to 2.6.
> 
> I'm trying to find the call stack after a low-level driver is loaded.  For example, after low-level driver calls scsi_register(), what's next, and how SCSI disks are registered with mid-level.
> 
> Thanks,
> 
> 
> Lee
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
