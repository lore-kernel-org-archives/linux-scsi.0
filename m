From: Fredrik Roubert <roubert@df.lth.se>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Thu, 23 Feb 2006 16:37:45 +0100
Message-ID: <20060223153745.GB8644@igloo.df.lth.se>
References: <Pine.LNX.4.60.0602140000160.18538@poirot.grange> <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange> <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se> <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se> <Pine.LNX.4.60.0602162121020.4944@poirot.grange> <20060218224121.GA21399@igloo.df.lth.se> <Pine.LNX.4.60.0602191740070.3542@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:7614 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S1751406AbWBWPh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 10:37:58 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0602191740070.3542@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun 19 Feb 21:54 CET 2006, Guennadi Liakhovetski wrote:

> 2) your problem might be in hardware rather than in software. For the
> latter I have to ask you if your cables are ok? Termination? Maybe
> replace the cable? Do you have any other SCSI card where you also cou=
ld
> test your scanner?

The scanner works OK when connected to my old AHA1542 controller in my
old computer. The two SCSI controllers have different connectors, so th=
e
cable I'm using now is also new, and untested. It could, no doubt, be a
problem with either the cable or the SCSI controller hardware.

> After you confirm that your cables and termination are fine,

It's fine, as far as I know. It's a brand new cable and I just plugged
it in replacing the old cable. Do you have any suggestions as to how I
could test cable and termination?

> I would ask you to do a few more tests to look more exactly at what's
> happening, and to verify at least the non-sg path of my patch. So, wo=
uld
> you agree to help me further with the tests or would you rather or wo=
uld
> you prefer to stop now?

Of course I'd like to help out. (How else would Linux continue to
improve?) Just tell me what you want me to do.

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
