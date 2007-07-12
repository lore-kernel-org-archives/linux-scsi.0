From: Jeremy Linton <jlinton@greshamstorage.com>
Subject: Re: [PATCH][BUG] Incorrect SCSI transfer length computation from
 odd sized scsi_execute_async() transfers.
Date: Wed, 11 Jul 2007 21:25:00 -0500
Message-ID: <469590FC.3090703@greshamstorage.com>
References: <46957820.9090008@greshamstorage.com> <469581BA.4010009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatekeeper.greshamstorage.com ([216.143.252.225]:27005 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764947AbXGLC2J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 22:28:09 -0400
In-Reply-To: <469581BA.4010009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jeremy Linton <jli@greshamstorage.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Scsi <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>

Mike Christie wrote:
> I think you needed some other bits in there. See this patch 
> I tried just setting the bufflen first, and that still had problems. 
> Could you try the patch here
> 
> http://marc.info/?l=linux-scsi&m=117392208211297&w=2


I just read the thread.. I didn't see any strange retries with my test 
case. I will try duplicating the problem tomorrow. Then I will apply 
your patch and rerun my test.

I'm curious if this has been known since 2.6.19 why the patch hasn't 
propagated to the main kernel tree?


