From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Thu, 11 Aug 2016 15:53:26 +0000
Message-ID: <bug-151661-11613-vqtUpXHoGP@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59232 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbcHKPxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2016 11:53:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 50204202EC
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 15:53:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 187DB2024D
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 15:53:27 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #1 from Piotr Szymaniak <bugzie@grubelek.pl> ---
(I'm a kernel bugzilla newbie and as newbie I'm not sure how much attention
gets kernel bugzilla and do this gets along with mailing lists and the other
way around. So I'm posting here my answers to David Carroll questions [1]
(snipped just a bit))

# -- 
> Hi Piotr,
>
> You had indicated that a kernel using Alex Williamson's patch allowed
> you to use the system correctly. Is that true?

Hi David,

I had to review my findings as I was a bit lost after trying so many
different settings and Live distros. With intel_iommu=igfx_off on
vanilla 4.7.0 kernel:
- it works (Gentoo Linux) with Alex patch
- it doesnt work (Gentoo Linux) without Alex patch


> You also indicated that Ubuntu 14.04 worked, while 16.04 did not. Is
> that true?

Ubuntu 14.04 (and speaking here about Ubuntu I mean running amd64 image
from usb stick - not sure, but I think it is 14.04.4 as it was latest
available week+ ago) it doesnt print "AAC: Host adapter dead -1" and it
works.

Ubuntu 16.04 (as above, it is 16.04.1) every 10 seconds prints about
"dead adapter", but works. When I've added intel_iommu=on on boot it
doesnt work (similar DMAR errors as posted in dmesg without Alex patch).

(both Ubuntus are amd64)


> Looking at the aacraid driver shipped with the Ubuntu flavors seems to
> be the same version of the driver. Do either of those kernel's have
> Alex's patch applied for the 3805?

I just used Live images so, sadly, I just dont know.


> At this point, assuming the above statements are true, I would believe
> that you would get the best results when using a kernel with Alex's
> patches applied.

Yeah, but I would love to get rid of those messages printed every ~10
seconds or at least know why they're there if adapter seems to work
fine? If Ubuntu 14.04 and 16.04 share the same driver why one of them
prints those messages and the other doesnt?
# -- 

[1] https://www.mail-archive.com/vfio-users@redhat.com/msg01747.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
