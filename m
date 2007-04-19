From: Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] add two SCSI command opcodes
Date: Thu, 19 Apr 2007 19:39:59 +0300
Message-ID: <20070419163959.GA25595@localdomain>
References: <20070419151053.GA10199@localdomain> <20070419154743.GA18325@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noname.neutralserver.com ([70.84.186.210]:60079 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766867AbXDSQk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 12:40:26 -0400
Content-Disposition: inline
In-Reply-To: <20070419154743.GA18325@lug-owl.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, Apr 19, 2007 at 05:47:43PM +0200, Jan-Benedict Glaw wrote:
> On Thu, 2007-04-19 18:10:54 +0300, Dan Aloni <da-x@monatomic.org> wrote:
> > diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> > index 5c0e979..dff842a 100644
> > --- a/include/scsi/scsi.h
> > +++ b/include/scsi/scsi.h
> > @@ -103,6 +103,7 @@ extern const unsigned char scsi_command_size[8];
> >  #define READ_12               0xa8
> >  #define WRITE_12              0xaa
> >  #define WRITE_VERIFY_12       0xae
> > +#define VERIFY_12             0xaf
> >  #define SEARCH_HIGH_12        0xb0
> >  #define SEARCH_EQUAL_12       0xb1
> >  #define SEARCH_LOW_12         0xb2
> > @@ -111,6 +112,7 @@ extern const unsigned char scsi_command_size[8];
> >  #define WRITE_LONG_2          0xea
> >  #define READ_16               0x88
> >  #define WRITE_16              0x8a
> > +#define WRITE_VERIFY_16       0x8e
> >  #define VERIFY_16	      0x8f
> >  #define SERVICE_ACTION_IN     0x9e
> >  /* values for service action in */
> 
> Where's the user?

A privately maintained kernel driver.

Do we _must_ have in-tree users? I'd consider the change for completion's
sake.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
