From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Mon, 23 Sep 2002 07:40:47 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D1F2@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Anton Blanchard' <anton@samba.org>
Cc: linux-raid@vger.kernel.org, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Anton,

Actually, I have written just such a user-space service (sgraidmon) to
monitor the SCSI bus, and it does implement SAF-TE, but not SES yet.
See http://scsirastools.sourceforge.net/ for more info and downloads.

Andy

-----Original Message-----
From: Anton Blanchard [mailto:anton@samba.org] 
Sent: Friday, September 20, 2002 7:57 PM
To: Cress, Andrew R
Cc: linux-raid@vger.kernel.org; 'linux-scsi@vger.kernel.org'; 'Mads Peter
Bach'; Jens Arnfelt
Subject: Re: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)


Hi,

> The premise I had was that this should take place automatically when a
scsi
> device is hot-inserted, rather than requiring intervention and knowledge
> from the sys admin.  In short, it should work more like a hardware RAID
> solution would.

It would be great if we could also have a SCSI Enclosure driver to
handle insert and removals. This could all be in userspace (using the SG
ioctl). In fact I played with some code from Matt Jacob a while ago and
hacked it about to do scsi-add-single+raidhotadd and
raidhotremove+scsi-remove-single.

Do your drive cases support SES?

Anton
