From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 10:04:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113100424.A26197@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org> <1068744259.13580.41.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:41682 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264382AbTKMSF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 13:05:29 -0500
Content-Disposition: inline
In-Reply-To: <1068744259.13580.41.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 10:24:19AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On Thu, Nov 13, 2003 at 10:24:19AM -0700, Pat LaVarre wrote:

> > I don't see what this has to do with variations of reset.  The examples of
> > USB traces from a Windows host that people have posted recently show no
> > use of MODE-SENSE.
> 
> I missed these, help?

http://marc.theaimsgroup.com/?l=linux-scsi&m=106836761130746&w=2

Showed the sequence:

	INQUIRY length 0x24 (36) bytes
	READ CAPACITY
	TEST UNIT READY
	READ CAPACITY
	READ 10

-- Patrick Mansfield
