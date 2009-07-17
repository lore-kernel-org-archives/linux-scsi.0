From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 17 Jul 2009 15:58:14 GMT
Message-ID: <200907171558.n6HFwEPh016658@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58695 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934700AbZGQP6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 11:58:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6HFwEKx016659
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 15:58:14 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #9 from Kay Sievers <kay.sievers@vrfy.org>  2009-07-17 15:58:14 ---
On Fri, Jul 17, 2009 at 17:36, <bugzilla-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13783
>
> So I entered the exact same command "hal-disable-polling
> --device /dev/scd0" again, which created the additional file
> "/etc/hal/fdi/information/media-check-disable-storage_model_Optiarc_DVD_RW_AD_7560S.fdi"
> and in fact ended the events permanently, even after a reboot.

Ah good.

> Except if I open the DVD drive: Then events are fired wildly (not just one or
> two) and the cpu usage rises to about 30% for a few seconds, until it stops
> again. The same thing happens when I close the drive. I don't know whether this
> is normal?

I guess something goes crazy with the media-changed detection.
Sometimes not-tested-in-such-setup/broken firmware for optical drives
does not like us.

We have seen similar behavior on some drives with HAL checking for the
"eject button pressed" events.

In some rare cases there are updates for the drive firmware available.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
