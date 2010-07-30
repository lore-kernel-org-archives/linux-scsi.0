From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8]: qla4xxx: bug fixes and PCI AER support
Date: Fri, 30 Jul 2010 10:38:53 -0500
Message-ID: <4C52F20D.1020406@cs.wisc.edu>
References: <20100730085518.GA12252@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42388 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0G3PfJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 11:35:09 -0400
In-Reply-To: <20100730085518.GA12252@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, nilesh.javali@qlogic.com, lalit.chandivade@qlogic.com

On 07/30/2010 03:55 AM, Vikas Chaudhary wrote:
> James,
>
> Please apply following list of patches which are generated against
> latest scsi-misc-2.6 tree.
>
> Vikas Chaudhary (5)
> 0001-qla4xxx-set-correct-value-in-sess-recovery_tmo.patch
> 0002-qla4xxx-Use-the-correct-request-queue.patch
> 0004-qla4xxx-clear-AF_DPC_SCHEDULED-flage-when-exit-from-.patch
> 0005-qla4xxx-updated-mbx_sys_info-struct-to-sync-with-FW-.patch
> 0008-qla4xxx-Update-driver-version-to-5.02.00-k3.patch
>
> Lalit Chandivade (2)
> 0003-qla4xxx-Stop-firmware-before-doing-init-firmware.patch
> 0007-qla4xxx-Added-AER-support-for-ISP82xx.patch
>
> Nilesh Javali (1)
> 0006-qla4xxx-Handle-outstanding-mbx-cmds-on-hung-f-w-scen.patch
>

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
