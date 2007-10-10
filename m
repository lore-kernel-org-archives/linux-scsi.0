From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
 if the adapter lacks one
Date: Wed, 10 Oct 2007 11:40:10 -0400
Message-ID: <470CF25A.9050403@garzik.org>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org> <470B9E50.2090205@emulex.com> <20071009164147.GB19854@plap3.qlogic.org> <20071009170643.GE16003@tree.beaverton.ibm.com> <470CE78B.2080509@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbXJJPkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2007 11:40:24 -0400
In-Reply-To: <470CE78B.2080509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

James Smart wrote:
> So, what's the decision - are we only allowing this for physical adapters
> that don't have a name ? or are we allowing it to be more dynamic ?

At a minimum, I think(?) we all agree that current upstream aic94xx 
behavior is nice:  allow the admin to override the WWN manually, even if 
the adapter already has one.

As to the question of request_firmware() versus sysfs, it's IMO largely 
a question of taste -- do you like the "get property" on-demand pull 
model, or a push model that presumes the property must be set before it 
is needed?  And which solution requires the least amount of additional 
userspace machinery in order to be usable?

	Jeff


