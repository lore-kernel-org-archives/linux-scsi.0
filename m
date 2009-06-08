From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] ibmvscsi: Send adapter info before login
Date: Mon, 08 Jun 2009 15:19:57 -0500
Message-ID: <4A2D726D.7060808@linux.vnet.ibm.com>
References: <200906031454.n53EsIr8011153@d01av04.pok.ibm.com> <1244491773.4079.595.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38442 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZFHUT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:19:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n58KH1Jn010050
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 14:17:01 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58KJwbr226006
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 14:19:58 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58KJwJl014332
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 14:19:58 -0600
In-Reply-To: <1244491773.4079.595.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com

James Bottomley wrote:
> On Wed, 2009-06-03 at 09:54 -0500, Brian King wrote:
>> The ibmvscsi driver currently sends the SRP Login before sending the Adapter
>> Info MAD, which can result in commands getting sent to the virtual adapter
>> before we are ready for them. This results in a slight window where the target
>> devices may not behave as expected. Change the order and close the window.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/ibmvscsi/ibmvscsi.c |  173 +++++++++++++++++++--------------------
>>  1 file changed, 85 insertions(+), 88 deletions(-)
> 
> This one just doesn't want to apply:
> 
> patching file drivers/scsi/ibmvscsi/ibmvscsi.c
> Hunk #4 FAILED at 961.
> Hunk #5 succeeded at 1279 (offset -3 lines).
> Hunk #6 succeeded at 1289 (offset -3 lines).
> 1 out of 6 hunks FAILED -- saving rejects to file
> drivers/scsi/ibmvscsi/ibmvscsi.c.rej
> 
> Could you check scsi-misc and see what's up?

I'll pull it down and take a look. This series should be applied
on top of 

http://marc.info/?l=linux-scsi&m=124388641607027&w=2

although I'm not sure that one liner could be causing all the trouble...

-Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


