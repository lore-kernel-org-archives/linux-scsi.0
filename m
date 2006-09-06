From: "Mohit Katiyar" <katiyar.mohit@gmail.com>
Subject: Fibre channel and scsi naming
Date: Wed, 6 Sep 2006 11:05:03 +0900
Message-ID: <46465bb30609051905m2a046cacx8138f37b410dd603@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:4829 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S965260AbWIFCFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Sep 2006 22:05:04 -0400
Received: by wr-out-0506.google.com with SMTP id i2so567364wra
        for <linux-scsi@vger.kernel.org>; Tue, 05 Sep 2006 19:05:03 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

In my program implementation on SLES 9 I was using the path
/sys/class/scsi_host/host<host_no_for fibre channel
adapter>/device/<host>:<channel>:<id>:<lun> entry to detect whether a
disk is attached through fibre channel or some other channel.

Now on SLES 10 the entry has been changed as
/sys/class/scsi_host/host<host_no_for fibre channel
adapter>/device/rport<some
numbers>/target<host:channel:id>/<host>:<channel>:<id>:<lun>

Can anyone tell me what are the new rport entries and how and who
creates them. Is it possible to get the rport entries for scsi disk
through scsi ioctls?

I could also see an entry as
/sys/class/fc_transport/target<host>:<channel>:<id>/device/<host>:<channel>:<id>:<lun>
on SLES 10. Can I use these entries to check whether a device is
registered through fibre channel adapter. Also which program populates
the fc_transport entries?


TIA
Mohit
