From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] move iscsi to a better place in Kconfig
Date: Fri, 09 Sep 2005 10:01:03 -0500
Message-ID: <1126278063.4799.15.camel@mulgrave>
References: <1126191378.4845.8.camel@mulgrave>
	 <43208FA2.8070304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59815 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751416AbVIIPBO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 11:01:14 -0400
In-Reply-To: <43208FA2.8070304@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Alex Aizman <itn780@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-09-08 at 14:23 -0500, Mike Christie wrote:
> I think the reason it was a dependency was becuase the transport class 
> manages does the lifetime management/refcounting for the 
> initiators/iscsi_tcp.c session struct. scsi_transport_iscsi allocates 
> the scsi_host, and the initiator/iscsi_tcp.c's session structure is 
> allocated in that host_data.

Yes, but Kconfig isn't about lifetimes or, in fact, much of the way the
code is constructed; it's about how the user selects particular
features.

In the current setup, they have to know to say Y/M to the ISCSI
attribute question even to see the config option for the iscsi
initiator.  This is a bit counter intuitive (and definitely isn't the
way any of the other drivers that depend on transport classes are
presented).

James


