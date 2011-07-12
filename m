From: Rob Evers <revers@redhat.com>
Subject: lpfc_debugfs_dumpHBASlim_data() stack space use
Date: Tue, 12 Jul 2011 15:57:20 -0400
Message-ID: <4E1CA720.1040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab1GLT5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 15:57:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Smart <James.Smart@Emulex.Com>

  Hi James S.

I noticed:

static int
lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
{
         int len = 0;
         int i, off;
         uint32_t *ptr;
         char buffer[1024];


Would 'char *buffer=kmalloc()' be more appropriate here?

Rob
