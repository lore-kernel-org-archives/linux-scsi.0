From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: LIO-Target Core v3.0.0 imported in k.o git
Date: Tue, 20 May 2008 15:48:17 -0700
Message-ID: <1211323697.14731.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:47304 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935049AbYETWs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 18:48:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Open iSCSI <open-iscsi@googlegr>
Cc: nab@kernel.org, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rwalker@medallion.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>, Grant Grundler <grundler@google.com>, Mike Mazarick <mazarick@bellsouth.net>, Bryan Black <bdblinux@gmail.com>, Sig Lange <sig.lange@gmail.com>, Hannes Reinecke <hare@suse.de>

Greetings all,

The LIO-Target Core v3.0.0 tree has been imported from v2.9-STABLE from
Linux-iSCSI.org source tree repositories into kernel.org git, and is
building w/ v2.6.26-rc3.  It can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

I will be continuing the cleanup activies for upstream, which so far has
included the removal of legacy unused engine level mirroring/replication
bits (as we are using LIO-DRBD or LIO-NR1 w/ MD for this now), and a few
LINUX_VERSION_CODE removals.  

[nab@hera lio-core]$ wc -l *.c *.h | tail -n 1
  57879 total

The goal now will be to seperate out the LIO-Target / LIO-Core pieces
for moving the latter upstream initially (eg a working passthrough, and
then v3.0 LIO-Target using traditional iSCSI, then iWARP and iSER.  This
will all be going into the roadmap on Linux-iSCSI.org for reference.

I invite interested parties to have a look, and please contact me on the
LIO-Target devel list, or privately if you would like to get involved
looking at some code that are in line with your
knowledge/interests/projects.

Many thanks for your most valuable of time,

--nab




