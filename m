From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Thu, 12 Oct 2006 12:48:39 -0500
Message-ID: <1160675319.3432.34.camel@mulgrave.il.steeleye.com>
References: <452E0A5C.6020001@aboo.org>  <452E7A9A.3000501@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39047 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750873AbWJLRsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 13:48:46 -0400
In-Reply-To: <452E7A9A.3000501@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-10-13 at 03:25 +1000, Aboo Valappil wrote:
> I wanted to make a NDMP (A protocol used to manage tapes and perform 
> backup/resotre on NAS heads)  initiator for Linux (Just out of my 
> interest).. I was not very good with doing stuff inside the kernel. 
> First my idea was to modify the Cisco iSCSI initiator and make it for 
> NDMP. But i found, it is too much of work + I already had a user space 
> implimentation of NDMP procedures. So I thought of making a virtual HBA 
> and expose the SCSI mid-layer to a user space application.

We actually already have an existing target infrastructure project here:

http://git.kernel.org/git/?p=linux/kernel/git/tomo/linux-2.6-target.git;a=summary

It seems to be very similar to yours ... could you see how easy it would
be for you to integrate with this project?

Thanks,

James


