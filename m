From: RKK <kulkarni.ravi4@gmail.com>
Subject: understanding the SCSI Specification.
Date: Mon, 1 Aug 2011 14:41:06 +0530
Message-ID: <CAM=x7SY_H_+=v4QT0-is7pS4S-YfFw0+JRPcO0KjQY549_wayw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33042 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1HAJLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 05:11:07 -0400
Received: by vws1 with SMTP id 1so4276097vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2011 02:11:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kernelnewbies <kernelnewbies@kernelnewbies.org>

HI all,
Im working on a storage protocol   which uses SCSI commands  set as
the command set and also the SCSI Task Management functions for
processing the Task Management.
The Architectural Model is based on SAM-5. The Command set is based on
SPC-4 and SBC-3. I have some doubts in trying to understanding some
SCSI terms and definitions.

For  using the send command transport protocol service request to
request a initiator  the following API is defined

[1]Send SCSI Command (IN (I_T_L_Q Nexus, CDB, Task Attribute, [Data-in
Buffer Size], [Data-
out Buffer], [Data-out Buffer Size], [CRN], [Command Priority], [First
Burst Enabled]))

Here  I want to know what relation does the I_T_L_Q tries to convey.
from what it says in SAM-5 Specification  section 4.8 tries to define
the Nexus as " nexus represents a relationship between a SCSI
initiator port, a SCSI target port, optionally a logical unit,
and optionally a command."
 how do we convey this information in the above [1].
Also can someone help me in how to map the initiator-target relation
to host-device  structure? thanks.

Warm Regards,
Ravi Kulkarni.





Warm Regards,
Ravi Kulkarni.
