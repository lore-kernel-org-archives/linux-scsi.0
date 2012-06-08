From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: How to detect if a libata ioctl SG_IO had an error?
Date: Fri, 8 Jun 2012 14:28:09 +0900 (JST)
Message-ID: <376140.35021.qm@web100009.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100009.mail.kks.yahoo.co.jp ([114.111.98.183]:47049 "HELO
	web100009.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933493Ab2FHF2M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jun 2012 01:28:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wrote:

> Now for today's discovery.
>=20
> When the SG_IO ioctl times out, libata sets the ABRT bit but not the =
ERR bit in the sense data.=A0 I was checking the ERR bit which was 0, a=
nd then going off on a wild goose chase trying to find what level SCSI =
driver reported the timeout error.=A0 There was none.=A0 It's all in th=
e ABRT bit.=A0 This looks like a bug in libata.

Wrong.  When the SG_IO ioctl times out, a lot of random values are stil=
l useless, and I'm still going off on wild goose chases.

How can the caller of ioctl detect if an error occured, where error inc=
ludes timeout as well as other kinds of errors?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
