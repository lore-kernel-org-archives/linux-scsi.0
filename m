From: Sangamesh O Shetty <sangameshs@vayavyalabs.com>
Subject: Query related to the UPIU endianess
Date: Tue, 13 Sep 2016 22:36:09 +0530
Message-ID: <CAJtufDtZ=HuzOctELgsbZP6-0z5ecs1kVzdYTM-4mWZ1FAbtXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35564 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbcIMRGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2016 13:06:31 -0400
Received: by mail-yw0-f170.google.com with SMTP id u82so43327719ywc.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 10:06:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org

Hi all,

I have a query related to the endianess of the UPIU packet.

The JESD223C document mentions that the CDB should be in big-endian.
The JESD220C document section 10.7 mentions the layout of all the UFS
UPIU's. It mentions that the first byte is transaction type, second
byte is flags and so forth. So when the UPIU is encoded in the UTRD
descriptor then the UPIU's transaction type will come as the third
byte of CDB and task tag will comes as first byte of CDB after
converting to big-endian.

But when I looked at the Linux driver(refer here the macro
UPIU_HEADER_DWORD), the transaction type is considered as byte zero
and task tag as byte three after it is converted to big-endian.

So my query is that what is the endianess of the UPIU packed that is
described in the JESD220C document.

wwr,
Sangamesh
