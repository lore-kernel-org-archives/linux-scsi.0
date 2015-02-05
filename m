From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 5 Feb 2015 18:57:58 +0000
Message-ID: <20150205185758.GC9303@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
 <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
 <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi>
 <995891679.6002631.1423158020737.JavaMail.zimbra@redhat.com>
 <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
 <20150205185040.GB9303@localhost.localdomain>
 <1423162550.5848.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbBES6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2015 13:58:22 -0500
Content-Disposition: inline
In-Reply-To: <1423162550.5848.21.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>, Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, Shane M Seymour <shane.seymour@hp.com>, linux-scsi@vger.kernel.org, jeffm@suse.com

On Thu, Feb 05, 2015 at 10:55:50AM -0800, James Bottomley wrote:
> OK, the sysfs bikeshedders hang out on linux-api
> 
> https://www.kernel.org/doc/man-pages/linux-api-ml.html
> 
> If you can convince them, we'll do the single file approach.

Will do - I've got a couple of stats projects on the go at the moment so
this ties in well with that.

I'll sync up with Shane and see if he's interested in running the int array
version via the linux-api folks.

Regards,
Bryn.

