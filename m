From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: Configuring the device_list in scsi_scan.c
Date: Fri, 31 May 2002 09:24:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D59@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi@vger.kernel.org

Alan,

I agree whole heartedly; the reason for my proposal is it seems that
that work would be a bit much to issue as a patch for 2.4. (admittedly,
this is said by someone whose never really been involved in the patch
process....)

In addition, I was trying to find a solution easy enough that I could
convince my boss that I should spend the time writing it. :-P

--
Michael Heinz
Infinicon Systems, Inc.
http://www.infiniconsys.com 

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Thursday, May 30, 2002 9:40 PM
> To: Heinz, Michael
> Cc: Matthew Dharm; linux-scsi@vger.kernel.org
> Subject: RE: Configuring the device_list in scsi_scan.c
> 
> 
> On Fri, 2002-05-31 at 01:10, Heinz, Michael wrote:
> > And I want to do that for each of, say, 128 devices, that 
> may or may not
> > be plugged in that day? It would be better to get the 
> midlayer to scan
> > for devices.
> > 
> > The correct fix is to have the mid layer support the REPORT_LUNS
> > command; but that's a major change - and probably wouldn't 
> get into 2.4
> > as a patch - which is why I proposed this instead.
> 
> I'd like to see a clean use of REPORT_LUNS as default for 
> SCSI3 capable
> devices. That would be a clean up that justified the testing work.
> 
> 
