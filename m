From: John Summerfield <summer@os2.ami.com.au>
Subject: Re: /proc/scsi/map
Date: Sat, 15 Jun 2002 22:08:54 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206151408.g5FE8s731047@numbat.Os2.Ami.Com.Au>
References: <garloff@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from Kurt Garloff <garloff@suse.de>
   of "Sat, 15 Jun 2002 15:36:06 +0200." <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


> 
> Life would be easier if the scsi subsystem would just report which SCSI
> device (uniquely identified by the controller,bus,target,unit tuple) belongs
> to which high-level device. The information is available in the kernel.


Does this not fail if I pull a device off, change its ID (perhaps to fit into another system), then plug it in again? Or if I move it from one adaptor to another?





-- 
Cheers
John Summerfield

Microsoft's most solid OS: http://www.geocities.com/rcwoolley/

Note: mail delivered to me is deemed to be intended for me, for my disposition.

==============================
If you don't like being told you're wrong,
	be right!



