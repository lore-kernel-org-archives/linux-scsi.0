From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 00/18] qla2xxx: Updates for scsi-misc-2.6
Date: Tue, 19 Apr 2011 14:26:41 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A9D523D@AVEXMB1.qlogic.org>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:2923
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab1DSV0r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2011 17:26:47 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>

James,

I had submitted 18 patches on March 30th. Please let me know the status on these.

I've included the link for 00/18 of this set.

http://marc.info/?l=linux-scsi&m=130151107627961&w=2

Thanks,
Madhu

> -----Original Message-----
> From: madhu.iyengar@qlogic.com [mailto:madhu.iyengar@qlogic.com]
> Sent: Wednesday, March 30, 2011 11:46 AM
> To: James.Bottomley@suse.de
> Cc: Giridhar Malavali; Madhu Iyengar; Andrew Vasquez; linux-
> scsi@vger.kernel.org; Madhu Iyengar
> Subject: [PATCH 00/18] qla2xxx: Updates for scsi-misc-2.6
>
> From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
>
> James,
>
> Please add these patches. Thanks.
>
> Andrew Vasquez (7):
>   qla2xxx: Display PortID information during FCP command-status
>     handling.
>   qla2xxx: Correct calling contexts of qla2x00_mark_device_lost() in
>     async paths.
>   qla2xxx: Check for a match before attempting to set FCP-priority
>     information.
>   qla2xxx: Remove extraneous setting of FCF_ASYNC_SENT during
>     login-done completion.
>   qla2xxx: Free firmware PCB on logout request.
>   qla2xxx: Update copyright banner.
>   qla2xxx: Verify login-state has transitioned to PRLI-completed.
>
> Chad Dupuis (1):
>   qla2xxx: Log fcport state transitions when debug messages are
>     enabled.
>
> Giridhar Malavali (6):
>   qla2xxx: Updated the reset sequence for ISP82xx.
>   qla2xxx: Remove extra call to qla82xx_check_fw_alive().
>   qla2xxx: Perform FCoE context reset before trying adapter reset for
>     ISP82xx.
>   qla2xxx: Display hardware/firmware registers to get more information
>     about the error for ISP82xx.
>   qla2xxx: Add the ql2xdontresethba module_param.
>   qla2xxx: Limit the logs in case device state does not change for
>     ISP82xx.
>
> Joe Carnuccio (1):
>   qla2xxx: Add test for valid loop id to qla2x00_relogin().
>
> Madhuranath Iyengar (2):
>   qla2xxx: Update License file.
>   qla2xxx: Update version number to 8.03.07.03-k.
>
> Mike Hernandez (1):
>   qla2xxx: Include request queue ID in the upper 16-bits of the I/O
>     handle for Abort I/O IOCBs.
>
>  Documentation/scsi/LICENSE.qla2xxx  |  292
> ++++++++++++++++++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_attr.c     |    4 +-
>  drivers/scsi/qla2xxx/qla_bsg.c      |    2 +-
>  drivers/scsi/qla2xxx/qla_bsg.h      |    2 +-
>  drivers/scsi/qla2xxx/qla_dbg.c      |    2 +-
>  drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
>  drivers/scsi/qla2xxx/qla_def.h      |   10 +-
>  drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
>  drivers/scsi/qla2xxx/qla_fw.h       |    2 +-
>  drivers/scsi/qla2xxx/qla_gbl.h      |    5 +-
>  drivers/scsi/qla2xxx/qla_gs.c       |    2 +-
>  drivers/scsi/qla2xxx/qla_init.c     |   45 ++++--
>  drivers/scsi/qla2xxx/qla_inline.h   |   21 +++-
>  drivers/scsi/qla2xxx/qla_iocb.c     |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c      |   43 ++++--
>  drivers/scsi/qla2xxx/qla_mbx.c      |   24 ++-
>  drivers/scsi/qla2xxx/qla_mid.c      |    4 +-
>  drivers/scsi/qla2xxx/qla_nx.c       |   59 ++++++-
>  drivers/scsi/qla2xxx/qla_nx.h       |    2 +-
>  drivers/scsi/qla2xxx/qla_os.c       |   43 +++++-
>  drivers/scsi/qla2xxx/qla_settings.h |    2 +-
>  drivers/scsi/qla2xxx/qla_sup.c      |    2 +-
>  drivers/scsi/qla2xxx/qla_version.h  |    6 +-
>  23 files changed, 499 insertions(+), 79 deletions(-)


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

