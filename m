From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 0/12] qla4xxx: Updates for scsi "misc" branch.
Date: Wed, 22 Aug 2012 06:29:33 -0700
Message-ID: <CC5ADBB9.11353%vikas.chaudhary@qlogic.com>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34658
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2HVN3n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 09:29:43 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>


linux-scsi list rejected patch "qla4xxx: Rename macros from 82XX to 8XXX"
for probable junk email.
Rename patch to "qla4xxx: Rename 82XX macros" and resending in next email.


-----Original Message-----
From: Vikas <vikas.chaudhary@qlogic.com>
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, Mike Christie
<michaelc@cs.wisc.edu>
Cc: scsi <linux-scsi@vger.kernel.org>, Vikas <vikas.chaudhary@qlogic.com>,
Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand
<ravi.anand@qlogic.com>
Subject: [PATCH 0/12] qla4xxx: Updates for scsi "misc" branch.

>From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>
>James,
>
>Please apply the following patches to the scsi tree at your earliest
>convenience.
>
>Following patches are to add support for our new adapter ISP83XX.
>
>Patch 01/12 to 07/12 is just to change function, variable, structure,
>macros name so that common functions for ISP82xx and ISP83xx include
>string "8xxx" in there name and functions only for ISP82xx will include
>string "82xx" in there name.
>
>Thanks,
>Vikas.
>
>Vikas Chaudhary (12):
>      qla4xxx: Update function name from 8xxx to 82xx
>      qla4xxx: Update structure and variable names
>      qla4xxx: Update func name from ql4_ to qla4_
>      qla4xxx: Rename macros from 82XX to 8XXX
>      qla4xxx: Clean-up and optimize macros
>      qla4xxx: Added new functions in isp_ops
>      qla4xxx: Replace all !is_qla8022() with is_qla40XX()
>      qla4xxx: Set IDC version in correct way
>      qla4xxx: Added new function qla4_8xxx_get_minidump
>      qla4xxx: Added support for ISP83XX
>      qla4xxx: Update Copyright header
>      qla4xxx: Update driver version to 5.03.00-k0
>
>
> drivers/scsi/qla4xxx/Kconfig       |    4 +-
> drivers/scsi/qla4xxx/Makefile      |    2 +-
> drivers/scsi/qla4xxx/ql4_83xx.c    | 1468
>++++++++++++++++++++++++++++++++++++
> drivers/scsi/qla4xxx/ql4_83xx.h    |  262 +++++++
> drivers/scsi/qla4xxx/ql4_attr.c    |   26 +-
> drivers/scsi/qla4xxx/ql4_dbg.c     |   32 +-
> drivers/scsi/qla4xxx/ql4_dbg.h     |    2 +-
> drivers/scsi/qla4xxx/ql4_def.h     |   60 ++-
> drivers/scsi/qla4xxx/ql4_fw.h      |   50 ++-
> drivers/scsi/qla4xxx/ql4_glbl.h    |   90 ++-
> drivers/scsi/qla4xxx/ql4_init.c    |   23 +-
> drivers/scsi/qla4xxx/ql4_inline.h  |    2 +-
> drivers/scsi/qla4xxx/ql4_iocb.c    |   28 +-
> drivers/scsi/qla4xxx/ql4_isr.c     |  254 +++++--
> drivers/scsi/qla4xxx/ql4_mbx.c     |  110 ++--
> drivers/scsi/qla4xxx/ql4_nvram.c   |    2 +-
> drivers/scsi/qla4xxx/ql4_nvram.h   |    2 +-
> drivers/scsi/qla4xxx/ql4_nx.c      | 1430
>+++++++++++++++++++++++------------
> drivers/scsi/qla4xxx/ql4_nx.h      |  198 +++--
> drivers/scsi/qla4xxx/ql4_os.c      |  414 +++++++----
> drivers/scsi/qla4xxx/ql4_version.h |    4 +-
> 21 files changed, 3553 insertions(+), 910 deletions(-)
> create mode 100644 drivers/scsi/qla4xxx/ql4_83xx.c
> create mode 100644 drivers/scsi/qla4xxx/ql4_83xx.h


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

