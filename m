From: Joern Quillman <quillman@fbihome.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Mon, 20 Nov 2006 11:52:45 +0100
Message-ID: <456188FD.3020108@fbihome.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:12522 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S1755909AbWKTKzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 05:55:11 -0500
In-Reply-To: <455E4703.3080005@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> FWIW, sbp2 in Linux 2.6.19-rcX sets the allow_restart flag for all HDDs
> and other direct access devices. In Linux 2.6.18 it does so only for
> Maxtor disks. Beyond setting that flag or leaving as it is, the sbp2
> driver has nothing to do with the restart facility; it's a thing between
> the SCSI error handler and the target. Of course the firmware of the
> FireWire bridge has to support it in the first place. I have no data
> which OXFW911 firmwares do or don't.
> 
> Also I don't remember which Linux release has the patch that exposes the
> allow_restart flag as a writable sysfs attribute but I suppose if you
> can see this attribute, then you have the patch. I can set and unset it
> with echo on 2.6.19-rc4 just fine, as root of course.

I tried 2.6.19-rc6 and it works just like you said. Thank's a lot for 
the hint.
One problem left. I still can't set or unset the flag with echo even on 
2.6.19-rc6 (as root). Always getting a write error. Not that I care much 
about this, 'cause I for sure don't want it disabled.
But it's strange nonethless.

Thank's again

Joern
