From: aboo <aboo@aboo.org>
Subject: Re: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Fri, 13 Oct 2006 8:13:24 +1000
Message-ID: <c3b66b980e163824b0079e07578624da@aboo.org>
References: <1160675319.3432.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:21418 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S1751198AbWJLWSq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 18:18:46 -0400
In-Reply-To: <1160675319.3432.34.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Thanks James,

Is'nt this a target implimentation, rather than a initiator? That page does not give me more details. I have sent an email to the author of the project to get more details. Hopefully, they will reply :)

Aboo

On Thu, 12 Oct 2006 12:48:39 -0500, James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-10-13 at 03:25 +1000, Aboo Valappil wrote:
>> I wanted to make a NDMP (A protocol used to manage tapes and perform
>> backup/resotre on NAS heads)  initiator for Linux (Just out of my
>> interest).. I was not very good with doing stuff inside the kernel.
>> First my idea was to modify the Cisco iSCSI initiator and make it for
>> NDMP. But i found, it is too much of work + I already had a user space
>> implimentation of NDMP procedures. So I thought of making a virtual HBA
>> and expose the SCSI mid-layer to a user space application.
> 
> We actually already have an existing target infrastructure project here:
> 
> http://git.kernel.org/git/?p=linux/kernel/git/tomo/linux-2.6-target.git;a=summary
> 
> It seems to be very similar to yours ... could you see how easy it would
> be for you to integrate with this project?
> 
> Thanks,
> 
> James

-------------------------------------
Aboo.Org - Compliments From A & J :)
-------------------------------------


