From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: attaching to the sas transport class
Date: Sat, 18 Mar 2006 09:24:05 -0600
Message-ID: <1142695445.3241.4.camel@mulgrave.il.steeleye.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
	 <1142646304.7462.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18623 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964777AbWCRPYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 10:24:11 -0500
In-Reply-To: <1142646304.7462.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

On Fri, 2006-03-17 at 17:45 -0800, Alexis Bruemmer wrote:
> -       sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
> -                       &port->disc.pending);
> -

I'm afraid we can't really do this ... what it's actually doing is
removing anything that would tamper with the infinite lifetimes (like
port removal events).  What we have to do is go the other way and make
all the object lifetimes consistent.

James


