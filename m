From: nmala@mail.com
Subject: Regarding Umount
Date: Sun, 04 May 2003 09:52:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030504145234.83566.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 205-158-62-158.outblaze.com ([205.158.62.158]:14233 "HELO
	spf1.us.outblaze.com") by vger.kernel.org with SMTP id S263618AbTEDOk2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2003 10:40:28 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

What exactly does umount write?? Every time I umount my pseudo driver there are two calls to request with readwrite flag set to 1. Haven't been able to find a corresponding write in the trace of umount.

Regards,
Mala
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

