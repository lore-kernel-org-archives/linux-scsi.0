From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: [PATCH] 2.4.23
Date: Wed, 31 Dec 2003 07:14:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA201EE1F2@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.203.33.17] ([65.203.33.17]:23085 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S265169AbTLaPOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2003 10:14:47 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Shall I generate a patch that uses a function pointer in the blacklist,
to poke at the inquiry data, for 2.4 ?  

Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@steeleye.com]
> Sent: Sunday, December 28, 2003 2:46 PM
> To: Christoph Hellwig
> Cc: Frank Borich; SCSI Mailing List
> Subject: Re: [PATCH] 2.4.23
> 
> On Sun, 2003-12-28 at 14:10, Christoph Hellwig wrote:
> > I'm not too happy about the form of this patch. Could you cook up
one
> > for 2.6.0 that adds a function pointer to poke at the inquiry data
> > to the blacklist?  We could backport it to 2.4 later.
> 
> Actually, this can't really be done at all for 2.6 since we're
extremely
> careful not to get inquiry data beyond byte 56 and this patch is
looking
> into the vendor specific area at 96.
> 
> James
> 

