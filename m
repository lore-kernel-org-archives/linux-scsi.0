From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 5 Nov 2004 12:01:40 -0500
Message-ID: <04Nov5.120116est.333377@cyborg.cybernetics.com>
References: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:22795 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262729AbUKERZC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 12:25:02 -0500
In-Reply-To: <C18BA5DDB58DD511BD0700C0DF0DD4501EEC6A@NTSERVER4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'SUPPORT' <support@4bridgeworks.com>, 'Matthew Wilcox' <matthew@wil.cx>, 'Thomas Babut' <thomas@babut.net>
Cc: 'Linux SCSI' <linux-scsi@vger.kernel.org>

> I have also seen drives that do unexpected disconnects if they get
sent PPR.

I too have seen a single-ended Exabyte Mammoth tape drive go to
unexpected bus free right after receiving the second byte of the PPR
extended message (01 06 - bus free).  Evidently it does not expect to
receive an extended message of that length.

I submitted a patch to sym53c8xx_2 in lk 2.4.x a few days ago to avoid
PPR on a SE or HVD bus, which fixes the problem for me.

Anthony J. Battersby
Cybernetics

