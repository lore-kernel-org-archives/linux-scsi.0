From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: emulex FC driver on ppc64
Date: Sun, 11 Apr 2004 07:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C01654@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42897 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262347AbUDKL7U
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Apr 2004 07:59:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Garzik' <jgarzik@pobox.com>
Cc: 'Anton Blanchard' <anton@samba.org>, linux-scsi@vger.kernel.org

There's no misunderstanding - I agree with you.  Just stating that the
reorganization and removal of the multi-os abstractions had to take place
first....

-- james

> -----Original Message-----
> From: Jeff Garzik [mailto:jgarzik@pobox.com]
> Sent: Saturday, April 10, 2004 8:45 PM
> To: Smart, James
> Cc: 'Anton Blanchard'; linux-scsi@vger.kernel.org
> Subject: Re: emulex FC driver on ppc64
> 
> 
> Smart, James wrote:
> > Anton,
> > 
> > Thanks for the feedback. I know we've only recently been 
> working things out
> > on the PPC64.  Most of the things look pretty minor - we 
> should be able to
> > get them in shortly. As for the MAX 32 - we've been looking 
> at raising the
> > count as well, but prioritized it below all the other work 
> items we've got
> > on the current list.
> 
> I think you misunderstand Anton's suggestion, which I agree with:
> 
> If you dynamically allocate the structures, there is no need for any 
> limit at all.  Most Linux drivers dynamically allocate these 
> structures 
> already, but a few (mostly simple) drivers do not.
> 
> In the future, dynamic allocation of these types of 
> structures will be a 
> requirement, in order to proper object lifetime (ref counting etc.) 
> management.
> 
> 	Jeff
> 
> 
