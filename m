From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Sun, 10 Aug 2008 00:00:24 +0200
Message-ID: <200808100000.25402.rjw@sisk.pl>
References: <20080809225153.2fdb23a8@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:47019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYHIV5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2008 17:57:41 -0400
In-Reply-To: <20080809225153.2fdb23a8@neptune.home>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bruno =?iso-8859-15?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Saturday, 9 of August 2008, Bruno Pr=E9mont wrote:
> Hi,

Hi,

> Trying out 2.6.27-rc2-git4 on a VIA Ester + CX700 based system I
> experience the following panic using a config obtained with make
> oldconfig from working 2.6.26 config.
>=20
> Looking at the traces and when it happens it looks like it could be
> libATA or SCSI related...
>=20
>=20
> Note: the kernel is patched with viafb patches sent yesterday ([y]) a=
nd
> squashfs (<m>)

Could you retest without these two, please?

Thanks,
Rafael
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
