From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Why REPORT LUN only for SCSI-2?
Date: Fri, 18 Jul 2003 08:38:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1795D5.F1FBECFB@fujitsu-siemens.com>
References: <3F140D30.D2B5C4D8@fujitsu-siemens.com> <20030715073927.A8218@beaverton.ibm.com> <3F14F7FA.BA551505@fujitsu-siemens.com> <20030716123519.A19244@beaverton.ibm.com> <3F16649C.239EC87B@fujitsu-siemens.com> <20030717184909.GD2520@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:65323 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S271722AbTGRGXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2003 02:23:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>

Kurt Garloff wrote:

> > As a side note (probably starting a new thread) why does BLIST_LARG=
ELUN
> > override max_scsi_luns?
>=20
> It shouldn't. Did I really do this? (... checking 2.4 code ...)
> No, I plead innocent.

Oops, I didn't check the info I got from a third party or I should go
and wash my ears B-{(
It's SPARSELUN which overrides max_scsi_luns:
	if (bflags & BLIST_SPARSELUN) {
		*max_dev_lun =3D shpnt->max_lun;
		*sparse_lun =3D 1;
                return 1;
        }
The objection still stands ...

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
