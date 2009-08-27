From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 02:34:09 -0400
Message-ID: <yq1my5l934u.fsf@sermon.lab.mkp.net>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	<4A95226E.8030504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:53346 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZH0GeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 02:34:21 -0400
In-Reply-To: <4A95226E.8030504@panasas.com> (Boaz Harrosh's message of "Wed,
	26 Aug 2009 14:54:22 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> I know that we also have the above problem with iscsi and
Boaz> data-digest such that when we come to sign the data it might
Boaz> change on us before the target receives it.

Yep, I have the same problem.  I talked to Andrew Morton a couple of
months ago and he said that modifying pages in flight is "a feature" as
far as ext[234] is concerned.

-- 
Martin K. Petersen	Oracle Linux Engineering
