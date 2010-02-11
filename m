From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: iscsi bugfixes and features for scsi-misc
Date: Thu, 11 Feb 2010 10:45:29 +0200
Message-ID: <4B73C3A9.5040503@panasas.com>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:4358 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777Ab0BKIpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 03:45:32 -0500
In-Reply-To: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 02/11/2010 12:51 AM, michaelc@cs.wisc.edu wrote:
> The following patches were made over scsi-misc plus this
> patch
> http://marc.info/?l=linux-scsi&m=126335810027706&w=2

OK The above patch:
	PATCH 1/1] iscsi_tcp regression: remove bogus warn on in write path

Is it not in main line? It causes me grate pain that one please submit into
2.6.33-rc ASAP

Boaz
> which is not yet merged (that patch fixes a regression
> in 2.6.33 and should go in there).
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

