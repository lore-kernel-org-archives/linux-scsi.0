From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: 21 Jun 2004 12:22:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087838573.2079.51.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:17296 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266333AbUFURXC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:23:02 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: Eric Dean Moore <Emoore@lsil.com>
Cc: viro@parcelfarce.linux.theplanet.co.uk, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 12:09, Moore, Eric Dean wrote:
> Somebody had submitted this change in the last week,
> along with the comment in that patch:
> 
> "The only way crap below could work..."
> 
> I had not seen the patch on this mailing list. 
> I would like revert back to its previous bits since I don't see
> what was broken with it.  These headers in the lsi folder are 
> the mpi interface to the mpt firmware, and are bundled with 
> all operating systems, etc. window, netware, solaris, unixware, etc.

Hmm, this looks to be the source of it:

http://linus.bkbits.net:8080/linux-2.5/cset@40d35407OdMFtEZ-f6GS5ylvSptSqQ

Although it should perhaps have come through the SCSI tree, the header
change looks correct.  Your S32 and U32 are int32_t and u_int32_t.

James


