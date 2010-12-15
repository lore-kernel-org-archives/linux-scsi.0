From: adam radford <aradford@gmail.com>
Subject: [PATCH 0/11]: Update megaraid_sas driver explanation
Date: Tue, 14 Dec 2010 18:40:18 -0800
Message-ID: <AANLkTi=xOBgxZ8eJuYbKUAjHQ-uC1rr-qdU8UT-vMt9H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56699 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0LOCkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 21:40:19 -0500
Received: by qwa26 with SMTP id 26so1473135qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 18:40:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "bo.yang" <bo.yang@lsi.com>

James/linux-scsi,

Please ignore the previous megaraid_sas patches 1 thru 9 from Bo Yang.
 They will be re-submitted at a later time.

The following patches update the megaraid_sas driver as follows:

1. Rename megaraid_sas.c to megaraid_sas_base.c
2. Update GPL headers.
3. Add MSI-X support and 'msix_disable' module parameter.
4. Use lowest memory bar (for SR-IOV VF support).
5. Add struct megasas_instance_template changes, and change all code to use new
   instance entries:

   irqreturn_t (*service_isr )(int irq, void *devp);
   void (*tasklet)(unsigned long);
   u32 (*init_adapter)(struct megasas_instance *);
   u32 (*build_and_issue_cmd) (struct megasas_instance *, struct scsi_cmnd *);
   void (*issue_dcmd) (struct megasas_instance *instance,
                              struct megasas_cmd *cmd);

6. Add MegaRAID 9265/9285 specific code to megaraid_sas_base.c.
7. Add MegaRAID 9265/9285 specific functions: megaraid_sas_fusion.c.
8. Add MegaRAID 9265/9285 megaraid_sas_fusion.h header.
9. Add MegaRAID 9265/9285 FastPath code.
10. Add MegaRAID 9265/9285 specific code to megaraid_sas.h.
11. Documentation/scsi/ChangeLog.megaraid_sas update.

-Adam
