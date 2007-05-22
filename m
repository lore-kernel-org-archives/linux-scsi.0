From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] FC Transport support for vports based on NPIV
Date: Tue, 22 May 2007 12:40:08 +0200
Message-ID: <20070522104007.GA21345@schmichrtp>
References: <1176408091.19824.20.camel@localhost.localdomain> <20070514121239.GA23620@schmichrtp> <464886B6.8050509@emulex.com> <20070521152718.GA15212@schmichrtp> <4651BE89.7020200@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:6845 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbXEVKkK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 06:40:10 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l4MAe9Rr161172
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 10:40:09 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4MAe9nO4141276
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 12:40:09 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4MAe8Hu016444
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 12:40:08 +0200
Content-Disposition: inline
In-Reply-To: <4651BE89.7020200@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, duane.grigsby@qlogic.com

On Mon, May 21, 2007 at 11:45:13AM -0400, James Smart wrote:

> True - so this means that who-ever is setting the subchannel device
> permanent_port_name value needs to take into account this conversation,
> when T11.3 actually makes a choice on what it should be.

I will keep this in mind. Probably this would involve the FCP adapter
and the reporting in zfcp.

Anyway, my main goal was to understand the changes in the FC transport
class and the possible impact to zfcp. Thanks for the clarification
of my questions.

Christof
