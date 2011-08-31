From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Aug 30 (scsi/qla4xxx)
Date: Wed, 31 Aug 2011 13:45:15 -0700
Message-ID: <20110831134515.049f584b.rdunlap@xenotime.net>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38859 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751411Ab1HaUpT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2011 16:45:19 -0400
In-Reply-To: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, iscsi-driver@qlogic.com

On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:

> Hi all,

[Sorry about the delay.. slow build machine.
Please ignore if this is already known/fixed.]


(on i386)

ERROR: "iscsi_boot_create_target" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_create_initiator" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

when CONFIG_ISCSI_BOOT_SYSFS is not enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
