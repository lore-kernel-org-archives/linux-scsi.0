From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Tue, 15 Jul 2003 07:39:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030715073927.A8218@beaverton.ibm.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:6335 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268095AbTGOOY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 10:24:27 -0400
Content-Disposition: inline
In-Reply-To: <3F140D30.D2B5C4D8@fujitsu-siemens.com>; from josef.moellers@fujitsu-siemens.com on Tue, Jul 15, 2003 at 04:18:24PM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Josef_M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 15, 2003 at 04:18:24PM +0200, Josef M=F6llers wrote:
> Hi,
>=20
> Ist there a hard reason not to allow the REPORT LUNS command for SCSI=
-2
> devices?

No.

> Are there actually some SCSI-2 devices which break on this command?

Probably, given the range of SCSI devices out there.

> There are several devices (e.g. RAID) which tread carefull and claim
> only SCSI-2 compliancy but support REPORT LUNS. It would make life
> easier with these if REPORT LUNS would be generally available.
> Eg I have a box which will happily accept INQUIRYs on LUNs 0-7 but
> REPORT LUNS returns only the 4 configured LUNs.

Are the unconfigured LUNs showing up as if they were configured?

Most disk/RAID arrays made in the last few years can configure whether
they report back as SCSI-2 or SCSI-3. It would be best if you could cha=
nge
the device to report as SCSI-3.

Even some SCSI disk drives are capable of reporting back as SCSI-2 or
SCSI-3.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
