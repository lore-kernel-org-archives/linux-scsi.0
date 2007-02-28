From: Douglas Gilbert <dougg@torque.net>
Subject: Re: end to end error recovery musings
Date: Wed, 28 Feb 2007 08:46:42 -0500
Message-ID: <45E587C2.5010209@torque.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>	<yq14pp78rze.fsf@sermon.lab.mkp.net>	<20070227190236.58323a40@lxorguk.ukuu.org.uk>	<yq1r6sb7733.fsf@sermon.lab.mkp.net>	<20070227233946.7ad33a50@lxorguk.ukuu.org.uk> <yq1mz2z6wov.fsf@sermon.lab.mkp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1mz2z6wov.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Alan" == Alan  <alan@lxorguk.ukuu.org.uk> writes:
> 
>>> Not sure you're up-to-date on the T10 data integrity feature.
>>> Essentially it's an extension of the 520 byte sectors common in
>>> disk
> 
> [...]
> 
> Alan> but here's a minor bit of passing bad news - quite a few older
> Alan> ATA controllers can't issue DMA transfers that are not a
> Alan> multiple of 512 bytes without crapping themselves (eg
> Alan> READ_LONG). Guess we may need to add
> Alan> ap-> i_do_not_suck or similar 8)
> 
> I'm afraid it stops even before you get that far.  There doesn't seem
> to be any interest in adopting the Data Integrity Feature (or anything
> similar) in the ATA camp.  So for now it's a SCSI-only thing.
> 
> I encourage people to lean on their favorite disk manufacturer.  This
> would be a great feature to have on SATA too...

Martin,
SCSI to ATA Translation (SAT) is now a standard
(ANSI INCITS 431-2007) [and libata is somewhat
short of compliance].

Work on SAT-2 is now underway and one of the agenda
items is "end to end data protection" and is in the
hands of the t13 ATA8-ACS technical editor. So it
looks like data integrity is on the radar in the SATA
world.

See http://www.t10.org/ftp/t10/document.06/06-497r4.pdf
for more evidence of how SAS and SATA are converging
at the command and feature set level.

Doug Gilbert


