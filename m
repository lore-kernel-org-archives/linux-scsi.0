From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH] SAM-3 status codes
Date: Wed, 22 Jan 2003 18:30:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10301221830370.20139-100000@master.linux-ide.org>
References: <3E2F24DA.50206@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2F24DA.50206@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org


WOOHOO !

Thank you sir!


On Thu, 23 Jan 2003, Douglas Gilbert wrote:

> The perverse CHECK_CONDITION in include/scsi/scsi.h seems
> to have struck again (see "Can't burn DVD under 2.5.59 with
> ide-cd" thread on the linux kernel list). Most users of
> CHECK_CONDITION found out to their surprise that it is
> shifted 1 bit (right) from those values found in the
> standards.
> 
> The attachment marks the orginal list of SCSI status codes
> as deprecated and supplies defines taken from the most
> recent SAM-3 draft.
> 
> The patch is against 2.5.59 but may also be suitable for
> the lk 2.4 tree.
> 
> Doug Gilbert
> 

Andre Hedrick
LAD Storage Consulting Group

