From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/8] scsi_transport_iscsi: Exporting new attrs for iscsi
 session and connection in sysfs
Date: Tue, 28 May 2013 03:57:33 -0500
Message-ID: <51A4717D.8060107@cs.wisc.edu>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com> <1368093732-8524-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45444 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624Ab3E1I5m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 May 2013 04:57:42 -0400
In-Reply-To: <1368093732-8524-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

On 05/09/2013 05:02 AM, vikas.chaudhary@qlogic.com wrote:
> +	ISCSI_PARAM_DEF_TASKMGMT_TMO,

We currently have:

        ISCSI_PARAM_ABORT_TMO,
        ISCSI_PARAM_LU_RESET_TMO,
        ISCSI_PARAM_HOST_RESET_TMO,


Does your card just have the one timeout for all types of tmfs?

I think the interface to set timers for the different eh operations
should be generic.
