From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] [PATCH] scsi-dh-emc: fix activate vs set_params race
Date: Thu, 04 Apr 2013 18:11:41 -0500
Message-ID: <515E08AD.3060404@cs.wisc.edu>
References: <Pine.LNX.4.64.1304021954420.27554@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55583 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764883Ab3DDXLv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Apr 2013 19:11:51 -0400
In-Reply-To: <Pine.LNX.4.64.1304021954420.27554@file.rdu.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, Rob Evers <revers@redhat.com>

On 04/02/2013 07:09 PM, Mikulas Patocka wrote:
> Hi
> 
> This fixes a possible race in scsi_dh_emc. It is untested because I don't 
> have the hardware. It could happen when we reload a multipath device and 
> path failure happens at the same time.


I think this patch is ok. I do not have the hw to test it anymore.

If you wanted to test just to make sure it is safe you should bug Rob
Evers. He can help you find a machine in the westford lab that has it
