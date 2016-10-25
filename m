From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD
Date: Tue, 25 Oct 2016 12:23:40 +0530
Message-ID: <81470825e9a6238fff464f9135787090@mail.gmail.com>
References: <bug-179341-11613@https.bugzilla.kernel.org/> <bug-179341-11613-AWI3KvF9Wz@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34373 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757474AbcJYGxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2016 02:53:43 -0400
Received: by mail-yw0-f182.google.com with SMTP id w3so216711056ywg.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 23:53:42 -0700 (PDT)
In-Reply-To: <bug-179341-11613-AWI3KvF9Wz@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Hi,
 Please share driver logs with logging_level set to "0x3f8".

If driver cannot be unloaded and loaded,then the module parameter has to be
passed as kernel command line in the boot loader as
=E2=80=9Cmpt3sas.logging_level=3D0x3F8=E2=80=9D else if driver module can b=
e unloaded and
loaded then simply give logging_level=3D0x3F8 for insmod or modprobe.

Thanks,
 Chaitra

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
bugzilla-daemon@bugzilla.kernel.org
Sent: Friday, October 21, 2016 6:43 AM
To: linux-scsi@vger.kernel.org
Subject: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD

https://bugzilla.kernel.org/show_bug.cgi?id=3D179341

--- Comment #2 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
        Adapter Selected is a Avago SAS: SAS3008(C0)

Num   Ctlr            FW Ver        NVDATA        x86-BIOS         PCI Addr
---------------------------------------------------------------------------=
-

0  SAS3008(C0)  13.00.00.00    0b.02.00.03    08.31.00.00     00:0a:00:00
1  SAS3008(C0)  13.00.00.00    0b.02.00.03    08.31.00.00     00:08:00:00

--
You are receiving this mail because:
You are watching someone on the CC list of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in th=
e
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
