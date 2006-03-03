From: "amrut h" <h.amrut@gmail.com>
Subject: problem in hot adding scsi disk
Date: Fri, 3 Mar 2006 12:45:56 +0530
Message-ID: <702b51100603022315p5223ba83xac5166da55bed0ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.192]:22304 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1752071AbWCCHP5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 02:15:57 -0500
Received: by xproxy.gmail.com with SMTP id s7so398959wxc
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2006 23:15:56 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi All,

I have a query regarding hot addition of scsi disks. Currently i am
using Linux stock kernel 2.6.10. The machine contains an adaptec 7902
hardware controller with 3 scsi disk.

On trying to hot add a scsi disk using command
echo "- - -" > /sys/class/scsi_host/host0/scan,
sometimes the new disk is visible immediately, but sometimes this
rescan returns without any disk addition.

Is this a h/w related problem or the command is failing for some reasons?
Any pointers are welcome.


Also at bootup the disk are visible as /dev/sda, /dev/sdb, /dev/sdc.
Is it possible that if i hot remove /dev/sdb and then hot add it
again, it appears with different name for e.g. /dev/sdd (though till
now i have also got it with the same name :).

TIA for any suggestion.

Amrut
