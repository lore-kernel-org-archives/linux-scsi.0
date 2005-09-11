From: Lars Ziegler <lziegler@web.de>
Subject: sym53c8xx_2 scsi parity error
Date: Sun, 11 Sep 2005 19:01:39 +0200
Message-ID: <924702591@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:43486 "EHLO
	fmmailgate05.web.de") by vger.kernel.org with ESMTP
	id S1751091AbVIKRBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 13:01:41 -0400
Received: by fmmailgate05.web.de (8.12.10/8.12.10/webde Linux 0.7) with SMTP id j8BH1dAA018736
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2005 19:01:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

two weeks ago I just installed an Dawicontrol DC2976 UW SCSI controller and an HP C7438 tape drive. I'm running a SuSE 9.3 Prof distribution with Kernel 2.6.13. when taking backups to my tapes no error occurs. but when i try to restore data from streamer to my hd i always get scsi parity errors and the process is stopped. I tried different patches for the sym53c8xx_2 driver but no patch solved my problems. has any body an idea what i can do to get my tape drive work. Thanks a lot!
Lars


______________________________________________________________
Verschicken Sie romantische, coole und witzige Bilder per SMS!
Jetzt bei WEB.DE FreeMail: http://f.web.de/?mc=021193

