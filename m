From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 09:42:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202174202.GA1960@beaverton.ibm.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <Pine.LNX.4.58.0312011655240.26106@serv> <03120217260300.01630@naveenb-lnx.cisco.com> <1070383028.2345.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:41140 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262601AbTLBRjo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 12:39:44 -0500
Content-Disposition: inline
In-Reply-To: <1070383028.2345.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Tue, 2003-12-02 at 05:56, Naveen Burmi wrote:
> > Our assumption so far was that if a buffer is given to SCSI HBA driver, then 
> > nobody can touch the buffer until the HBA says that he is done with the 
> > buffer. It seems that this assumption isn't true. Can you give an instance 
> > where somebody (probably buffer cache) will modify the buffer which is handed
> > over to an HBA driver?
> 
> This is an incorrect assumption.  The Linux SCSI subsystem is
> architected for zero copy, meaning that if the user maps a copy of the
> data, they can alter it at will, even if it is in flight within the
> driver.  The only thing you can guarantee is that you will get another
> write request for any page the user dirtied.


The user would need to generate another write request and the
"guarantee" is up to the user (correct?)?

-andmike
--
Michael Anderson
andmike@us.ibm.com

