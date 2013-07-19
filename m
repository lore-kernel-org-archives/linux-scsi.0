From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 19 Jul 2013 09:58:49 -0600
Message-ID: <51E96239.8080409@cs.wisc.edu>
References: <cover.1369155164.git.agordeev@redhat.com>  <20130521235003.GE6985@mtj.dyndns.org>  <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>  <20130522170305.GD9563@kernel.dk>  <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>  <1373583637.7397.370.camel@haakon3.risingtidesystems.com>  <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>  <1373692812.7397.625.camel@haakon3.risingtidesystems.com>  <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>  <1374010683.7397.880.camel@haakon3.risingtidesystems.com>  <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>  <1374173515.7397.948.camel@haakon3.risingtidesystems.com>  <51E83E32.9050306@cs.wisc.edu> <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38364 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3GSP7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jul 2013 11:59:17 -0400
In-Reply-To: <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>

On 07/18/2013 06:23 PM, Nicholas A. Bellinger wrote:
>> Just saw this while trying out iscsi with the scsi-mq stuff :)
>> > 
> Took at stab at this a while back, but ended getting distracted on other
> items.  Do you have an initial conversion running yet..?

Not running well :) Have a patch but I am debugging it now. I messed up
something with the cmd_size stuff.
