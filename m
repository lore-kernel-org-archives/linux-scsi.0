From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: aacraid: Host adapter reset request. SCSI hang ? Adaptec 2820SA
Date: Fri, 6 Oct 2006 14:23:25 -0700
Message-ID: <40b437200610061423g3595bf55lcff9429fed84b399@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:25414 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S932641AbWJFVX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 17:23:27 -0400
Received: by nf-out-0910.google.com with SMTP id x30so1256273nfb
        for <linux-scsi@vger.kernel.org>; Fri, 06 Oct 2006 14:23:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am seeing the above message in logs.

Some times the system locks up, some times it continues. The OS
resides on the RAID array, so if the controller goes offline, the
system cannot continue running.

Any ideas what might be causing this?

I am running a RedHat AMD64 system, with kernel: 2.6.9-34.EL and
aacraid module version 1.1-5[2425].

More info:
#   grep aac /var/log/dmesg
Adaptec aacraid driver (1.1-5[2425])
aacraid0: kernel 5.1-0[9117]
aacraid0: monitor 5.1-0[9117]
aacraid0: bios 5.1-0[9117]
aacraid0: serial 504e8b
scsi0 : aacraid

Does anyone have any suggestions? The system has hung twice within the
space of 2 hours, so this is not good!

Regards,
Simon
