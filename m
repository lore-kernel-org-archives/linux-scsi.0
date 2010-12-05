From: "jack_wang" <jack_wang@usish.com>
Subject: Re: Re: mvsas errors in 2.6.36
Date: Sun, 5 Dec 2010 10:08:39 +0800
Message-ID: <201012051008390934167@usish.com>
References: <201010290650.32892.thomas@fjellstrom.ca>,
 <201012040554.31111.thomas@fjellstrom.ca>,
 <201012040844.47337.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas <thomas@fjellstrom.ca>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On December 4, 2010, Thomas Fjellstrom wrote:
> On December 4, 2010, Thomas Fjellstrom wrote:
> > On December 4, 2010, jack_wang wrote:
> > > 
[snip]
> 
> Even after the reboot it still happens, though with that change, it /seems/
> as if the pause is gone, but I can't be sure yet.
> 
Nope, pauses are still here, but they are shorter.

[Jack] Yes , once the host enter error handle , the scsi core will hold on the host(not sen IOs to the host as you see pause utill 
 the error are corrected). The main reason of the host go into error host is there are commands have no response utill the command
timer timeout, this maybe the disks need more time or the host lost interupt or some other reason.  You may need to change disks
and host part by part to see what cause the command timeout.
-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
__________ Information from ESET NOD32 Antivirus, version of virus signature database 5659 (20101129) __________
The message was checked by ESET NOD32 Antivirus.
http://www.eset.com
