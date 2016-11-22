From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD
Date: Tue, 22 Nov 2016 11:11:19 +0000
Message-ID: <bug-179341-11613-Plcx665fDs@https.bugzilla.kernel.org/>
References: <bug-179341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932708AbcKVLLX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 06:11:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 04EF420295
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 11:11:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 9D7D720272
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 11:11:19 +0000 (UTC)
In-Reply-To: <bug-179341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=179341

--- Comment #7 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
Help is needed. How to get a log FW? 

This is "SAS 9300-16i Host Bus Adapter" and not have any HW RAID. 

[root@nas sas3ircu_linux_x64_rel]# ./sas3ircu 0 LOGIR
Avago Technologies SAS3 IR Configuration Utility.
Version 14.00.00.00 (2016.07.21)
Copyright (c) 2009-2016 Avago Technologies. All rights reserved.

SAS3IRCU: The LOGIR command is not supported by the firmware currently loaded
on controller 0.

[root@nas sas3ircu_linux_x64_rel]# ./sas3ircu list
Avago Technologies SAS3 IR Configuration Utility.
Version 14.00.00.00 (2016.07.21)
Copyright (c) 2009-2016 Avago Technologies. All rights reserved.


         Adapter      Vendor  Device                       SubSys  SubSys
 Index    Type          ID      ID    Pci Address          Ven ID  Dev ID
 -----  ------------  ------  ------  -----------------    ------  ------
   0     SAS3008       1000h   97h    00h:0ah:00h:00h      1000h   3130h

         Adapter      Vendor  Device                       SubSys  SubSys
 Index    Type          ID      ID    Pci Address          Ven ID  Dev ID
 -----  ------------  ------  ------  -----------------    ------  ------
   1     SAS3008       1000h   97h    00h:08h:00h:00h      1000h   3130h
SAS3IRCU: Utility Completed Successfully.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
