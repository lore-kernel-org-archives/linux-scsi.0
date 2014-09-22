From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI test tool for linux (and others)
Date: Mon, 22 Sep 2014 10:34:12 -0600
Message-ID: <54204F84.8090509@acm.org>
References: <CAN05THQ9Z0sMgJ5gFZhLBP9JH+pmFYNVBr0KrgCCYF9=haFKbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:59212 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaIVQeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2014 12:34:23 -0400
In-Reply-To: <CAN05THQ9Z0sMgJ5gFZhLBP9JH+pmFYNVBr0KrgCCYF9=haFKbg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>, linux-scsi@vger.kernel.org

On 21/09/2014 9:58, ronnie sahlberg wrote:
> For now I populated it with a bunch of tests I copied fro the SCSI family.
> Some, not all, tests.
> Missing are a whole bunch of tests that require that you have multiple
> I_T nexuses,
> such as all the persistent reservation tests, which would be difficult
> to implement on /dev/sg* devices. (all users of a specific /dev/sg*
> device ends up on the same nexus, right, the nexus for kernel<->device
> ?)

Hello Ronnie,

Have you considered to allow multiple /dev/sg* arguments to be specified 
and to let the tests that require multiple I_T nexuses use one /dev/sg* 
argument per nexus ? Do you think such a feature would be helpful for 
testing FC and RDMA over SCSI initiator drivers in a setup with multiple 
storage paths between initiator and target systems ?

Thanks,

Bart.
