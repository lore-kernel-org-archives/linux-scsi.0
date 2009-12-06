From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] scsi: use __uX types for headers exported to user space
Date: Sun, 06 Dec 2009 21:34:37 +0100
Message-ID: <87k4wzrgde.fsf@macbook.be.48ers.dk>
References: <1259317748-27167-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:42680 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbZLFUee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2009 15:34:34 -0500
Received: by ey-out-2122.google.com with SMTP id 4so229459eyf.5
        for <linux-scsi@vger.kernel.org>; Sun, 06 Dec 2009 12:34:40 -0800 (PST)
In-Reply-To: <1259317748-27167-1-git-send-email-jacmet@sunsite.dk> (Peter
	Korsgaard's message of "Fri, 27 Nov 2009 11:29:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org

>>>>> "Peter" =3D=3D Peter Korsgaard <jacmet@sunsite.dk> writes:

 Peter> Commit 9e4f5e29 (FC Pass Thru support) exported a number of hea=
der files
 Peter> in include/scsi to user space, but didn't change the uX types t=
o the
 Peter> userspace-compatible __uX types. Without that you'll get compil=
e errors
 Peter> when including them - E.G.:

 Peter> /tmp/include/scsi/scsi.h:145: error: expected specifier-qualifi=
er-list
 Peter> before =E2=80=98u8=E2=80=99

 Peter> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Comments?

--=20
Bye, Peter Korsgaard
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
