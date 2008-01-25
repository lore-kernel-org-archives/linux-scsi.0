From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 18:05:55 -0500
Message-ID: <479A6B53.20306@garzik.org>
References: <20080122151857.GA8680@ubuntu.domain>	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>	 <4796BB5A.9090003@garzik.org>	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>	 <479727D5.8060901@garzik.org>	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com> <1201302003.3119.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59874 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761328AbYAYXF7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 18:05:59 -0500
In-Reply-To: <1201302003.3119.81.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

James Bottomley wrote:
> The lack of interrupt enable looks potentially fatal...

See my comments on this specific issue, in this thread, for the reason 
why that function isn't used...

	Jeff



