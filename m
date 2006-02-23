From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Thu, 23 Feb 2006 23:25:35 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602232311520.5883@poirot.grange>
References: <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
 <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se>
 <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se>
 <Pine.LNX.4.60.0602162121020.4944@poirot.grange> <20060218224121.GA21399@igloo.df.lth.se>
 <Pine.LNX.4.60.0602191740070.3542@poirot.grange> <20060223153745.GB8644@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:56194 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751304AbWBWWZg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 17:25:36 -0500
In-Reply-To: <20060223153745.GB8644@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

On Thu, 23 Feb 2006, Fredrik Roubert wrote:

> On Sun 19 Feb 21:54 CET 2006, Guennadi Liakhovetski wrote:
> 
> > 2) your problem might be in hardware rather than in software. For the
> > latter I have to ask you if your cables are ok? Termination? Maybe
> > replace the cable? Do you have any other SCSI card where you also could
> > test your scanner?
> 
> The scanner works OK when connected to my old AHA1542 controller in my
> old computer. The two SCSI controllers have different connectors, so the
> cable I'm using now is also new, and untested. It could, no doubt, be a
> problem with either the cable or the SCSI controller hardware.

Ok, if you could connect the scanner to the same PC but to a different 
SCSI card, that would with a good probability confirm that the scanner is 
ok. Still, it is at least theoretically possible, that a bug in the 
scanner's firmware is triggered by some, e.g., timing pattern specific to 
the dc315u, though within specs. Just to say I don't see a good way to 
exclude the scanner as the cause of the problem with 100% probability.

> > After you confirm that your cables and termination are fine,
> 
> It's fine, as far as I know. It's a brand new cable and I just plugged
> it in replacing the old cable. Do you have any suggestions as to how I
> could test cable and termination?

Not really. You have the same problem with the old and the new cable? 
Then, most probably, it's not the cause of the problem. Termination is 
switched on on the scanner or is it a passive terminator on the cable? 
E.g., on my scanner there's no active termination (I think).

> > I would ask you to do a few more tests to look more exactly at what's
> > happening, and to verify at least the non-sg path of my patch. So, would
> > you agree to help me further with the tests or would you rather or would
> > you prefer to stop now?
> 
> Of course I'd like to help out. (How else would Linux continue to
> improve?) Just tell me what you want me to do.

Great! While I am preparing a new debugging patch, could you, perhaps, 
test your scanner + dc315u + pc with some live Linux CDs? Some 32-bit i386 
like Knoppix, also interesting with 2.6 and 2.4 kernel?

Thanks
Guennadi
---
Guennadi Liakhovetski
