From: "Scott Murray" <scottm@somanetworks.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 19:00:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0210241839490.10937-100000@rancor.yyz.somanetworks.com>
References: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Steven Dake <sdake@mvista.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 24 Oct 2002, Randy.Dunlap wrote:

> Preface question:  does cPCI support surprise removal (in the
> PICMG specs, not in some implementation)?  I know that PCI hotplug
> doesn't support surprise removal, only "coordinated" removal.

No, according to PICMG 2.1 R2.0, suprise removal is "non-compliant".

> So the question that has to be answered IMO is:  do we want to
> support surprise removal for something like manufacturing test,
> which doesn't abide by the coordinated removal protocol?
>
> or:  Do we have to support surprise removal, only because it can't
> be prevented?  I expect that this is the case, but I still don't
> see or understand the 20 ms time requirement.

I've not implemented it yet, but I'm pretty sure I can detect surprise
extractions in my cPCI driver.  The only thing holding me back at the
moment is that there's no clear way to report this status change via
pcihpfs without doing something a bit funky like reporting "-1" in the
"adapter" node.

Scott


-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com

