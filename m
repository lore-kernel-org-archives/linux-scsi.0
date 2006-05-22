From: "Dan Carpenter" <error27@gmail.com>
Subject: mptspi doesn't work the nStor
Date: Mon, 22 May 2006 16:37:16 -0700
Message-ID: <a63d67fe0605221637i231d4b48n942461ccdf4ee470@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.195]:23348 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1751304AbWEVXhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2006 19:37:18 -0400
Received: by nz-out-0102.google.com with SMTP id 8so1433515nzo
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:37:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mpt_linux_developer@lsil.com

I can't get mptspi to work with my nStor in FC5.  I think it broke
when mptscsih get split up.  The split has been back ported to
sles9sp3 and rhel4u3 and it breaks those as well.

Are there any patches that make it work again?

Fedora Core 5 bugzilla
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=188487
RHEL 4u3 buzilla
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=190760

For now I've just forward ported the pre-split drivers.  That's not a
great long term solution but if anyone needs it I can send it to you.

regards,
dan carpenter
