From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: Asynchronous Event Reporting
Date: Wed, 17 Apr 2002 09:59:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C5E9B@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, linux-scsi@vger.kernel.org


> Michael,
> Yes I believe you are correct.
> 
> Sounds like an interesting challenge, though.
> 
>

LoL. Yup. Looks like a real "opportunity to excel" :-P

Seriously, from the current structure of the code I think anything doing
with AER would  be a major hack. It probably makes more sense to hold
off and deal with it as part of a complete rework of the scsi drivers.

