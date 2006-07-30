From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: RedHat EL4 install does not find RAID set with 3WARE 9550SX
Date: Sat, 29 Jul 2006 23:40:23 -0700
Message-ID: <40b437200607292340n1fa9a219q74b7ad34853f829a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:18477 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751127AbWG3GkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 02:40:24 -0400
Received: by py-out-1112.google.com with SMTP id t32so299191pyc
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2006 23:40:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been attempting to install RHEL4 (update 3) on a dual-Opteron
system with a 3WARE 9550SX RAID controller and 4 disks.

I have configured it with one exportable unit as RAID5. I have forced
a verify on this, yet the OS install disk will not recognise that any
disks exist in the system that can be used for the install. According
to 3WARE's  website, I should not need a driver disk as long as I am
using a release greater than U2 (which I am). In fact 3WARE does not
provide a driver disk for RHEL4 U3.

I have tried both 32 bit and 64-bit installs, with no success. During
the install process, it prompts me to load additional drivers and I
select the 3w-9xxxx driver.

The system rescue live CD can find the exported RAID unit -- I was
able to partition it when I booted from the System Rescue CD.

Does anyone have any suggestions?

Regards,
Simon
