From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: aic7xxx driver schedules() while holding spinlock
Date: Thu, 3 Jul 2003 16:42:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001b01c341a3$97af0410$e0019d89@cybernetics.com>
References: <Pine.LNX.4.44L0.0307031618140.779-100000@ida.rowland.org>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:8965 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S265367AbTGCU1p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 16:27:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307031618140.779-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Stern' <stern@rowland.harvard.edu>
Cc: 'SCSI development list' <linux-scsi@vger.kernel.org>

While on the subject, a while ago I discovered that sym53c8xx_2 in 2.4.x
holds a spinlock (io_request_lock) while calling ioremap() and
iounmap(), which can lead to deadlock on certain hardware.  If anyone is
doing a driver audit, it might be worth checking for this in other
drivers too.

Anthony J. Battersby
Cybernetics

