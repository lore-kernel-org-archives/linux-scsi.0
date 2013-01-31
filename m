From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Thu, 31 Jan 2013 11:27:56 -0500
Message-ID: <1359649676.4420.476.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3AaQ16 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2013 11:27:58 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0VGRvTW006596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2013 11:27:57 -0500
Received: from [10.16.186.175] (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0VGRv0p015935
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2013 11:27:57 -0500
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Thanks to everyone for the comments on this patch series.

Based upon the feedback, I'll be making the following changes
to the patch series before submitting it:

   - Remove patch 1/9 "Detect overflow of sense data buffer"
   - Change name of "sdev_evt_thread" to "sdev_evt_work"
   - Change name of "starget_evt_thread" to "starget_evt_work"
   - Pull code out of scsi_check_sense() that handles UAs into
     an exported function so that drivers can report conditions
     received asynchronously

The discussions about further changes (e.g. AEN, W-LUN) to
ensure conditions are reported to the host in the case of no
active I/O in progress or no LUNs currently presented have been
good.  I think this could be addressed with subsequent patches.

-Ewan

