From: Douglas Gilbert <dougg@torque.net>
Subject: [historical note] scsiinfo is 10 years old
Date: Tue, 04 Nov 2003 19:35:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FA845DA.1040001@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:54795 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262652AbTKEAf7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2003 19:35:59 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric@andante.org

While working on sginfo which is derived from scsiinfo
I noticed this line in the comments towards the top:

* Eric Youngdale - 11/1/93.  Version 1.0.

So scsiinfo is now over ten years old  **. The latest
scsiinfo version that I have found is 1.7 with the most
recent patches by Michael Weller from August 1997.

Scsiinfo is still useful with modern SCSI disks but lacks
support for recently added mode pages and enhancements to
existing mode pages.

So when I finish with sginfo's upgrade I might make some
addressing modifications and then release it as scsiinfo
2.0 if Eric has no objections.


** I guess that date is using the US convention and is the
day after halloween ... so my post is a few days late.

Doug Gilbert



