From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][SCSI] megaraid_sas: Fix synchronization problem between
 sysPD IO path and AEN path
Date: Wed, 16 Oct 2013 21:44:47 +0000
Message-ID: <1381959886.1864.25.camel@dabdike>
References: <201310161134.r9GBYYqK021397@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:39400 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3JPVot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 17:44:49 -0400
In-Reply-To: <201310161134.r9GBYYqK021397@cosmhbs0.lsi.com>
Content-Language: en-US
Content-ID: <0FA8E0BE393CCA4089086DCDA80EAAFC@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kashyap.desai@lsi.com" <kashyap.desai@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>

On Wed, 2013-10-16 at 17:04 +0530, Sumit.Saxena@lsi.com wrote:
> There is syncronization problem between sysPD IO path and AEN path. Driver maintains instance->pd_list[] array, which will get updated(by calling function megasas_get_pd_list[]), whenever any of below events occurs-
> 
> MR_EVT_PD_INSERTED
> MR_EVT_PD_REMOVED
> MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED
> MR_EVT_FOREIGN_CFG_IMPORTED
> 
> At same time running sysPD IO will be accessing the same array instance->pd_list[], which is getting updated in AEN path, because
> of this IO may not get correct PD info from instance->pd_list[] array.
> 
> Signed-off-by: Adam Radford <adam.radford@lsi.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>

Explain the signoff chain: is this a joinly authored patch?

James

