From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] fc class: fail fast bsg requests
Date: Thu, 5 Nov 2009 14:02:37 -0500
Message-ID: <4AF3214D.9000008@emulex.com>
References: <1257441489-9055-1-git-send-email-michaelc@cs.wisc.edu> <4AF31BFA.1030305@emulex.com> <4AF31FA7.3020602@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36804 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZKETCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2009 14:02:41 -0500
In-Reply-To: <4AF31FA7.3020602@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Mike Christie wrote:
> James Smart wrote:
>> Does this really do what you want ?  Don't you want something that 
>> dequeues the request, and errors it out ?
> 
> The dequeue and fail happens just below the code in the patch:

Ah - I was thinking of the check in the reverse....  Agree.

Acked-By: James Smart       <james.smart@emulex.com>

We'll have to address the rport teardown case independently.

-- james
