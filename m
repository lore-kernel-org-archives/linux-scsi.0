From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] lpfc: do not reset dev_loss_tmo in slave callout
Date: Fri, 06 Aug 2010 03:05:13 -0500
Message-ID: <4C5BC239.8080606@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39027 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab0HFIBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 04:01:21 -0400
In-Reply-To: <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com

On 08/06/2010 03:02 AM, michaelc@cs.wisc.edu wrote:
>
> +static void
> +lpfc_get_host_def_loss_tmo(struct Scsi_Host *shost)
> +{
> +        struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;

This part of the patch has whitespaces when I should have used tabs. git 
am --whitespace=fix will fix it up, or I can resend another patch if you 
want.
