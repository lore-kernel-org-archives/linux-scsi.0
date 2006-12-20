From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the queue
Date: Wed, 20 Dec 2006 17:50:51 -0600
Message-ID: <4589CC5B.9090704@greshamstorage.com>
References: <20061219083507.GA20847@localdomain> <1166522613.3365.1198.camel@laptopd505.fenrus.org> <4587C04E.10307@monatomic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:2555 "EHLO
	austin.greshamstorage.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050AbWLUAGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 19:06:20 -0500
In-Reply-To: <4587C04E.10307@monatomic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Arjan van de Ven <arjan@fenrus.demon.nl>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

> So instead of adding a parameter, we can make scsi_execute_async()
> decide for itself based on the SCSI command, with read/write I/Os
> taking the lowest priority.
	This seems like a bad idea, I can come up with a number of cases where 
the priority of a request would better be optimized by a higher level 
subsystem, rather than a simple prioritization based on the command type.

The original suggestion to provide both head and tail insertion options 
seems like the obvious solution, short of a full priority queuing system.




