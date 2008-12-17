From: bburk@extremeprotocol.com
Subject: RE: READ CAPACITY 16
Date: Wed, 17 Dec 2008 10:20:48 -0700
Message-ID: <20081217102048.a3c6426c1bfee0652ed014f32bc3b38e.0b45b81fab.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpoutwbe05.prod.mesa1.secureserver.net ([208.109.78.207]:33101
	"HELO smtpoutwbe05.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751421AbYLQRUt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 12:20:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Algorithm D is rather pointless.  Even if T10 added an Inquiry bit,
there's no guarentee that all devices will support it, especially older
devices made before the change so even if it got put in you STILL can't
rely on it and will have to all back to other methods to get the
information that you're looking for.

You may as well get T10 to require that all devices support RC16 without
locking up for as much good as it would do.  No device should be doing
it, so the ones that aren't handling it properly are out of spec anyway.




Brent Burkholder
Extreme Protocol Solutions



-------- Original Message --------
Subject: READ CAPACITY 16
From: Matthew Wilcox <matthew@wil.cx>
Date: Wed, December 17, 2008 11:42 am
To: linux-scsi@vger.kernel.org


Go back to T10 and say "Excuse me, kind sirs, would you mind adding an
INQUIRY bit to indicate that the device supports UNMAP? I know you've
added a bit to RC16, but there's this nasty real world out there where
devices are apt to blow up if you send them an RC16 when they're not
expecting it."



