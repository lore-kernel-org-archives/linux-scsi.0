From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Wed, 12 Nov 2003 16:13:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031112161310.A21175@beaverton.ibm.com>
References: <20031112155029.A20986@beaverton.ibm.com> <20031112160921.A10818@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:4044 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261776AbTKMAOA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 19:14:00 -0500
Content-Disposition: inline
In-Reply-To: <20031112160921.A10818@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Wed, Nov 12, 2003 at 04:09:21PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On Wed, Nov 12, 2003 at 04:09:21PM -0800, Matthew Dharm wrote:
> On Wed, Nov 12, 2003 at 03:50:29PM -0800, Patrick Mansfield wrote:
> > James - can you please apply? This should not affect other devices since
> > we are not changing the requested length, just the size of the receive
> > buffer.
> 
> This is a terrible idea.
> 
> There is a large number of devices which choke if those two values do not
> match.

This is what we do in 2.4 - does USB fix it up for 2.4?

Oh well.

-- Patrick Mansfield
