From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Mon, 8 Nov 2004 09:44:46 -0500
Message-ID: <04Nov8.094419est.332239@cyborg.cybernetics.com>
References: <1099714821.10944.27.camel@compaq-rhel4.xsintricity.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:31751 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261344AbUKHPDG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2004 10:03:06 -0500
In-Reply-To: <1099714821.10944.27.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>, 'Thomas Babut' <thomas@babut.net>
Cc: 'linux-scsi mailing list' <linux-scsi@vger.kernel.org>, 'Matthew Wilcox' <matthew@wil.cx>

> Finally, there are devices out there that do target initiated speed
> negotiations.  If we get an incoming PPR message from a device

The spec says:

"PPR may be originated by SCSI initiator ports but shall not be
originated by SCSI target ports."

"WDTR and SDTR may be originated by either SCSI target ports or SCSI
initiator ports."

Unless someone has seen a counter-example, the case of target-originated
PPR negotiations can probably be ignored.

Anthony J. Battersby
Cybernetics

