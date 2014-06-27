From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: help decoding aacraid errors (3.10.40 kernel)
Date: Fri, 27 Jun 2014 13:48:55 +0200
Message-ID: <201406271348.55739.a.miskiewicz@gmail.com>
References: <201406271055.08750.a.miskiewicz@gmail.com> <201406271259.18659.a.miskiewicz@gmail.com> <20140627113743.GE10042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41499 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaF0LtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 07:49:00 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so2679452wib.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 04:48:58 -0700 (PDT)
In-Reply-To: <20140627113743.GE10042@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Friday 27 of June 2014, Bryn M. Reeves wrote:
> On Fri, Jun 27, 2014 at 12:59:18PM +0200, Arkadiusz Miskiewicz wrote:
> > Thanks for links. I wonder why kernel doesn't decode these to be ac=
tually
> > readable without a need for asking on ml - was decoding considered?
>=20
> Normally it does; I was a bit surprised to see numbers printed with s=
uch
> a recent kernel.
>=20
> Sense key decoding to text has been around almost forever (the 'snste=
xt'
> table of sense strings pre-dates git, i.e. 2.6.12ish).
>=20
> Is it possible your kernel was built without CONFIG_SCSI_CONSTANTS?

Bingo! Thanks for your help.

--=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / maven.pl

Q: vger.kernel.org postmasters - always rude and impolite, hmm?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
