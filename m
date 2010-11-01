From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 01 Nov 2010 14:42:20 -0400
Message-ID: <4CCF0A0C.3070209@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box> <4CCEE33F.5030300@garzik.org> <20101101175742.GG25817@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0KASmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 14:42:24 -0400
Received: by mail-gw0-f46.google.com with SMTP id 21so3427335gwj.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 11:42:24 -0700 (PDT)
In-Reply-To: <20101101175742.GG25817@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 11/01/2010 01:57 PM, Andi Kleen wrote:
> ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6 hostlock2

FYI there is a merge conflict, when pulling this into current upstream:

 From ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6
  * branch            hostlock2  -> FETCH_HEAD
Auto-merging drivers/scsi/bfa/bfad_im.c
Auto-merging drivers/scsi/gdth.c
Auto-merging drivers/scsi/ipr.c
Auto-merging drivers/scsi/libfc/fc_fcp.c
Auto-merging drivers/scsi/lpfc/lpfc_scsi.c
Auto-merging drivers/scsi/megaraid/megaraid_sas.c
Auto-merging drivers/scsi/pmcraid.c
Auto-merging drivers/scsi/qla2xxx/qla_os.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
Auto-merging drivers/scsi/qla4xxx/ql4_os.c
Auto-merging drivers/staging/hv/storvsc_drv.c
Auto-merging net/core/sock.c
Automatic merge failed; fix conflicts and then commit the result.
