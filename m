From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Fri, 27 Feb 2009 10:09:18 -0500
Message-ID: <49A8021E.1050503@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:4581 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZB0Pi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 10:38:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

I tested Alan's original patch with sym53c8xx back in January:

http://marc.info/?l=linux-scsi&m=123143710010939&w=4

Tested-by: Tony Battersby <tonyb@cybernetics.com>

