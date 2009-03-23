From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Mon, 23 Mar 2009 15:05:04 -0400
Message-ID: <87f94c370903231205m235402b9t6ec1c77f8bdc0857@mail.gmail.com>
References: <20090123041558.GC24652@parisc-linux.org>
	 <4979AF62.7070409@redhat.com>
	 <1232721777.4430.7.camel@macbook.infradead.org>
	 <498DA052.6090605@redhat.com>
	 <1234019372.4658.9.camel@localhost.localdomain>
	 <498DB350.8000905@redhat.com>
	 <22BDA4D9BA18634DB0CFBB2E5A1563446F98BAE155@KFAEXMIPV1.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <22BDA4D9BA18634DB0CFBB2E5A1563446F98BAE155@KFAEXMIPV1.sdcorp.global.sandisk.com>
Sender: linux-ide-owner@vger.kernel.org
To: Eyal Shani <Eyal.Shani@sandisk.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 12, 2009 at 9:51 AM, Eyal Shani <Eyal.Shani@sandisk.com> wrote:
> Adding my 5 cents.
>
> T13 added Trim to the latest ATA8 proposal.
> http://www.t13.org/Documents/UploadedDocuments/docs2009/d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf
>
> This is after the changes put into the definition, with 'Deterministic Read after Trim'.
> This is not STANDARDIZED, but pretty much excepted by all sides.
>
> I was hoping that would settle the differences between T10/T13 on this - little did I know...
>
> We are working with David W. on his implementation for Trim feature, and hope to get to the bottom of debug process soon.
> Hope to update soon...
>
>
> Regards,
> Eyal Shani.

FYI:

Several of you remember I've been concerned about the lack of
"audit-ability" associated with the new Trim feature as relates to the
T13 spec.

I finally found a contact that is on the T-13 committee and have
expressed my concern.  He said the issue was raised at a recent
meeting of the committee and that a sub-group was tasked with making a
recommendation.  He said that he understands my concern and said he
would push to ensure that some sort of "reliable data" flag be in the
eventual spec.

Obviously he is just one person, so no guarantees, but I am happy to
have finally connected with someone on the committee.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
