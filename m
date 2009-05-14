From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: [RFQ] New driver architecture questions
Date: Wed, 13 May 2009 19:57:46 -0600
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762593AbZENCBp@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Kernel experts out there!

=20

We (a division of LSI Corp.) are planning to initiate a new driver desi=
gn for future generation of LSI RAID controllers. The new class of RAID=
 controllers would be supported under various operating systems in addi=
tion to Linux.

As part of the revamping exercise, we would like to design the driver i=
n such a fashion that much of the driver source code can be made common=
 across drivers offered for various operating systems.

The obvious benefits being:

1.                   Reduction of feature disparity across various oper=
ating systems.

2.                   Increased customer satisfaction in terms of suppor=
t consistency across all available operating systems.

3.                   More synergy between the driver team members and i=
ncreased collaboration.

4.                   Decreased overheads in terms of maintenance, fixin=
g issues across the board, defect and change requests tracking etc.

5.                   More channelized test engineering.

etc=85.

Our concern is, is such a design acceptable to Linux community, with ou=
r intention being keeping the model open source.

Insights, feedback would be highly appreciated!=20

Best regards,
Atul Mukker
Staff Engineer,
LSI Corp.--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
