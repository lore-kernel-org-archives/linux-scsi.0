From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD
Date: Tue, 22 Nov 2016 04:31:58 +0000
Message-ID: <bug-179341-11613-Ys0OeaYc4T@https.bugzilla.kernel.org/>
References: <bug-179341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754854AbcKVEcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 23:32:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 6473D2014A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 04:32:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 5398320253
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 04:31:58 +0000 (UTC)
In-Reply-To: <bug-179341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=179341

--- Comment #5 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
   13.434720] mpt3sas_cm0: device status change: (internal device reset)
        handle(0x0009), sas address(0x4433221100000000), tag(65535)

[   13.464810] scsi 0:0:1:0: tag#0 CDB: Inquiry 12 00 00 00 24 00
[   13.464844] mpt3sas_cm0:     sas_address(0x4433221100000000), phy(0)
[   13.464846] mpt3sas_cm0:    
enclosure_logical_id(0x500062b201056c80),slot(3)
[   13.464847] mpt3sas_cm0:     enclosure level(0x0000), connector name(    
^E)
[   13.464849] mpt3sas_cm0:     handle(0x0009), ioc_status(scsi ioc
terminated)(0x004b), smid(1)
[   13.464850] mpt3sas_cm0: Device Status Change
[   13.464852] mpt3sas_cm0:     request_len(36), underflow(0), resid(36)
[   13.464854] mpt3sas_cm0:     tag(0), transfer_count(0),
sc->result(0x000b0000)
[   13.464855] mpt3sas_cm0:     scsi_status(good)(0x00), scsi_state(state
terminated no status )(0x0c)
[   13.464861] mpt3sas_cm0: log_info(0x31111000): originator(PL), code(0x11),
sub_code(0x1000)
[   13.464867] mpt3sas_cm0: device status change: (internal device reset
complete)
        handle(0x0009), sas address(0x4433221100000000), tag(65535)

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
