From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Tue, 25 Jan 2005 12:40:07 -0600
Message-ID: <1106678407.6434.43.camel@mulgrave>
References: <OF09208441.E1CA6752-ONC1256F94.005CDE81-C1256F94.00647837@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9403 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262044AbVAYSls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 13:41:48 -0500
In-Reply-To: <OF09208441.E1CA6752-ONC1256F94.005CDE81-C1256F94.00647837@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, Heiko Carstens <Heiko.Carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, willy@www.linux.org.uk

On Tue, 2005-01-25 at 19:10 +0100, Martin Peschke3 wrote:
> Actually, you will find the adapter structure be an anchor for several
> other objects, or lists of them respectively. We tried to organize
> all the driver private data in a sane way. That means there is a tree
> of objects representing the SAN topology, including target ports and
> subordinate LUNs, many of which have an associated mid-layer structure.
> I can't imagine that anybody would ever argue to collapse all that into
> the adapter structure. So, why all the fuss about this particular object?
> The generic services object has nothing to do with the adapter. It's about
> fabric switch services, or certain well-known FC (target) ports, which can
> be accessed in the fabric through an adapter. It's not local but remote,
> like other targets, so to speak. We might also have chosen to call it
> "fabric switch".

OK, take a look at this:

http://marc.theaimsgroup.com/?l=linux-scsi&m=110546207223304

and tell me if it does everything you need.  If it doesn't, you could
try adding all the other bits to the fc transport class.

James


