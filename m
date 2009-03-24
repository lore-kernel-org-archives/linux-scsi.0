From: Madhukar G <madhukar.linux@gmail.com>
Subject: Understanding SAS
Date: Tue, 24 Mar 2009 18:04:44 +0530
Message-ID: <e79524560903240534x7b3c5376uc75bda4a3f65c170@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:41106 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZCXMet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 08:34:49 -0400
Received: by wa-out-1112.google.com with SMTP id j5so1774153wah.21
        for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 05:34:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I'm new to SAS architecture. I have sas1r10.pdf with me for
understanding the protocol. I'm looking at the sources available at
scsi/libsas.

I was looking at task management function sequence and non-data
command sequence for SSP frames in the specification. But i could not
map the same in source code. Can some help me understand in which
functions these sequences of SSP frames are handled.

Any help is much appreciated.

Thank You.

Regards,
Madhukar
