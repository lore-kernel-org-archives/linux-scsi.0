From: cshastri@linux.vnet.ibm.com
Subject: Testing NPIV Feature with Qemu-KVM
Date: Mon, 02 Sep 2013 08:54:31 -0400
Message-ID: <20130902085431.Horde.LEQA7Jir309SJIqHX5OkwvA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35716 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305Ab3IBMyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 08:54:36 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <cshastri@linux.vnet.ibm.com>;
	Mon, 2 Sep 2013 08:54:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qemu-devel@nongnu.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hare@suse.de


Hi All,

I am testing NPIV feature on upstream Qemu, I have configured the zone
and able to see the created vport on the storage array.

Since, I am learning on how to setup the NPIV, I haven't created the  
different zone for
the vport and the array, I just added in the existing zone.

Now, how do pass the LUN to the qemu, from Dr. Hannes Reineckei mail  
thread I got to know that lspci command on the host doesn't show the  
virtual HBA.

I didn't understand why there is limitation on that and if I specify
/usr/libexec/qemu-kvm -enable-kvm Fedora19 -m 3000 -smp 2 -net nic -net
\ user -vnc 127.0.0.1:0 -drive if=scsi,file=/dev/sdj

How do I make sure that qemu is using the virtual HBA or (vport)?

Thanks,
Shastri

