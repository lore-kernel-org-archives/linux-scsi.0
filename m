From: Fubo Chen <fubo.chen@gmail.com>
Subject: target: transport_get_lun_for_tmr() failure behavior
Date: Tue, 15 Feb 2011 21:02:49 +0100
Message-ID: <AANLkTinA2SMk=6y4Au0BbyS8O=m2P-D7+Y70Cr-gs8R8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1BOUCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 15:02:49 -0500
Received: by mail-iy0-f174.google.com with SMTP id 8so431983iyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2011 12:02:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

While trying figure out how transport_get_lun_for_tmr() works I
noticed that flag SCF_SCSI_CDB_EXCEPTION is set if LUN not found but
that se_cmd->scsi_sense_reason is not set. Is that on purpose ?

Same remark for transport_new_cmd_failure().

Fubo.
