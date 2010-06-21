From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 0/11] qla4xxx: bug_fix and ISP82xx support
Date: Mon, 21 Jun 2010 16:48:26 -0700
Message-ID: <5EEDAE5D-1BE7-43B1-900B-27C7715EAF1B@qlogic.com>
References: <20100616204902.GA8100@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:5128 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab0FUXs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2010 19:48:28 -0400
In-Reply-To: <20100616204902.GA8100@sles11sp1b1.qlogic.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>

James,

Are you planning to pull in all these patches once Mike ACK's patch 4 ?

Thanks
Ravi
On Jun 16, 2010, at 1:49 PM, Vikas Chaudhary wrote:

> James,
> 
> Please apply following list of patches which are generated against
> latest scsi-misc-2.6 tree. These patches are blessed by Mike.C and
> patches addresses comments in following threads:-
> 
> http://article.gmane.org/gmane.linux.scsi/59571
> http://article.gmane.org/gmane.linux.scsi/59572
> 
> We will hold on BSG patches for now to get everyone on common agreement.
> I will resubmit BSG patches after every one come to common agreement.  
> 
> Vikas Chaudhary (8)
> 0001-qla4xxx-set-driver-ddb-state-correctly-in-process_dd.patch
> 0002-qla4xxx-unblock-iscsi-session-after-setting-ddb-stat.patch
> 0003-qla4xxx-correct-return-status-in-function-qla4xxx_fw.patch
> 0004-qla4xxx-set-correct-value-in-sess-recovery_tmo.patch
> 0007-qla4xxx-Added-support-for-ISP82XX.patch
> 0008-qla4xxx-replace-all-dev_info-dev_warn-dev_err-with-q.patch
> 0010-iscsi_transport-added-new-iscsi_param-to-display-tar.patch
> 0011-qla4xxx-Update-driver-version-to-5.02.00-k2.patch
> 
> Ravi Anand (1)
> 0006-qla4xxx-Handle-one-H-W-Interrupt-at-a-time.patch
> 
> Prasanna Mumbai (1)
> 0005-qla4xxx-Fix-the-freeing-of-the-buffer-allocated-for-.patch
> 
> Karen Higgins(1)
> 0009-qla4xxx-wait-for-device_ready-before-device-discover.patch
> 
> drivers/scsi/qla4xxx/Kconfig        |    8 +-
> drivers/scsi/qla4xxx/Makefile       |    2 +-
> drivers/scsi/qla4xxx/ql4_def.h      |  146 ++-
> drivers/scsi/qla4xxx/ql4_fw.h       |  139 +++-
> drivers/scsi/qla4xxx/ql4_glbl.h     |  106 ++-
> drivers/scsi/qla4xxx/ql4_init.c     |  245 +++--
> drivers/scsi/qla4xxx/ql4_inline.h   |    2 +-
> drivers/scsi/qla4xxx/ql4_iocb.c     |   73 +-
> drivers/scsi/qla4xxx/ql4_isr.c      |  396 +++++-
> drivers/scsi/qla4xxx/ql4_mbx.c      |  191 ++-
> drivers/scsi/qla4xxx/ql4_nvram.c    |    2 +-
> drivers/scsi/qla4xxx/ql4_nvram.h    |   10 +-
> drivers/scsi/qla4xxx/ql4_nx.c       | 2317 +++++++++++++++++++++++++++++++++++
> drivers/scsi/qla4xxx/ql4_nx.h       |  779 ++++++++++++
> drivers/scsi/qla4xxx/ql4_os.c       |  751 +++++++++---
> drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
> drivers/scsi/scsi_transport_iscsi.c |    6 +-
> include/scsi/iscsi_if.h             |    2 +
> 
> Thanks,
> Vikas.

