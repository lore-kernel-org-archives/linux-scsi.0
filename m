From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sun, 8 Feb 2009 15:06:44 -0500
Message-ID: <87f94c370902081206v71106c5fp9a7ef0400301a1ab@mail.gmail.com>
References: <20090123041558.GC24652@parisc-linux.org>
	 <4979AF62.7070409@redhat.com>
	 <1232721777.4430.7.camel@macbook.infradead.org>
	 <498DA052.6090605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <498DA052.6090605@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 7, 2009 at 9:53 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
>
> I have been poked at by some vendors about the status of our support for the
> virtually/thinly provisioned luns since they are getting close to being able
> to test with real devices.

I found a list of T10 activities just since just Dec. 1, 2008 and it
is a bit overwhelming.  (ie. 08-356r4 is but one of many recent
reports)

http://www.t10.org/new_a.htm

For those of us that don't live and breath the SCSI spec, is there an
overview site describing what is going on.

Maybe:
09-059r0 	T10 Project Summary - January 2009 	John Lohmeyer 	PDF
(34729)	2009/01/22
http://www.t10.org/cgi-bin/ac.pl?t=d&f=09-059r0.pdf

I have not read any of the Post Dec. 1 stuff including the above
project summary, but based on the names these seem potentially
relevant:

09-055r0 	T13 Liaison Report January 09 	Dan Colegrove 	PDF (4770)	2009/01/15

08-356r4 	SBC-3: WRITE SAME unmap bit 	David L. Black 	PDF (56608)	2008/12/10

08-356r5 	SBC-3 Thin Provisioning Commands 	Fred Knight, David L.
Black 	PDF (387549)	2009/01/15

08-149r7 	SBC - Thin Provisioning 	Frederick Knight 	PDF (281001)	2008/12/08

08-149r8 	SBC - Thin Provisioning 	Frederick Knight 	PDF (281387)	2009/01/09

09-011r1 	SBC-3 Thin Provisioning Threshold Notification 	Frederick
Knight 	PDF (32757)	2009/01/09

08-149r9 	SBC - Thin Provisioning 	Frederick Knight 	PDF (353888)	2009/01/15

09-012r0 	Minutes: CAP - Thin Provisioning 12/4 con-call 	Frederick
Knight 	PDF (38063)	2008/12/08

09-011r0 	SBC-3 Thin Provisioning Threshold Notification 	Frederick
Knight 	PDF (48523)	2008/12/08

08-396r3 	SPC-4: Reporting support for all DIF types 	George Penokie
	PDF (85358)	2009/01/14

09-058r0 	Agenda for T10 Meeting #90 March 2009 	John Lohmeyer 	PDF
(61437)	2009/01/19

09-020r0 	T11 Liaison Report, December 2008 	Robert Snively 	PDF
(13117)	2008/12/19

09-032r0 	Minutes of T10 Plenary Meeting #89 - January 15, 2009 	Weber
& Lohmeyer 	HTM (141593)	2009/01/23

09-032r0 	Minutes of T10 Plenary Meeting #89 - January 15, 2009 	Weber
& Lohmeyer 	PDF (344891)	2009/01/23

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
