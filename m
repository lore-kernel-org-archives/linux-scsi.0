From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] qla4xxx: 5.04.00-k3: Updates for scsi "misc" branch
Date: Tue, 17 Dec 2013 01:23:46 -0600
Message-ID: <52AFFC02.4030709@cs.wisc.edu>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53898 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3LQHYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 02:24:45 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 11/22/13 4:28 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>
> James,
>
> Please apply the following patches to the scsi tree at your earliest convenience.
>
> These patches are on top of other qla4xxx patch posted on list here:
> http://marc.info/?l=linux-scsi&m=138210321629250&w=2
>
> Adheer Chandravanshi (4):
>        scsi_transport_iscsi: Export ISCSI_PARAM_LOCAL_IPADDR attr for iscsi_connection
>        libiscsi: Add local_ipaddr parameter in iscsi_conn struct
>        qla4xxx: Add support for ISCSI_PARAM_LOCAL_IPADDR sysfs attr
>        qla4xxx: Recreate chap data list during get chap operation
>
> Lalit Chandivade (2):
>        scsi_transport_iscsi: Add host statistics support
>        qla4xxx: Add host statistics support
>
> Vikas Chaudhary (2):
>        qla4xxx: Added support for Diagnostics MBOX command
>        qla4xxx: Update driver version to 5.04.00-k3
>

Patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

