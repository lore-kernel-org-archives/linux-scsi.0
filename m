From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/3] lpfc 8.2.8 v2 : recut of conflicting 8.2.8 patches
Date: Sun, 7 Sep 2008 11:57:20 -0400
Message-ID: <48C3F9E0.3020308@emulex.com>
References: <1220802706.6747.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62021 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYIGP5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 11:57:25 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m87FvPVO026694
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2008 08:57:25 -0700 (PDT)
In-Reply-To: <1220802706.6747.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

fyi - the patches were cut against scsi-post-merge-2.6

-- james s

Smart, James wrote:
> This patch set is reworked versions of 8.2.8 patches that were failing
> due to conflicts with the target busy and transport disrupted changes.
> 
> patch1 resolves the target_busy vs transport_disrupted status
> 
> patch2 is a recut of:
>   [PATCH 12/15] lpfc 8.2.8 : Add sysfs control of target queue depth handling
> 
> patch3 is a recut of:
>   [PATCH 14/15] lpfc 8.2.8 : Add statistical reporting control and additional
>     fc vendor events
> 
> -- james s
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
