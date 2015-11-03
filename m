From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/8] pm80xx: Add ATTO 12Gb HBA support and fix various issues
Date: Mon, 02 Nov 2015 23:44:31 -0500
Message-ID: <yq18u6f4rps.fsf@sermon.lab.mkp.net>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbbKCEoq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 23:44:46 -0500
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com> (Benjamin
	Rood's message of "Fri, 30 Oct 2015 10:53:23 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>

>>>>> "Benjamin" == Benjamin Rood <benjaminjrood@gmail.com> writes:

Benjamin> The following series of patches are primarily aimed at adding
Benjamin> support for ATTO's 12Gb SAS adapters, which are based off of
Benjamin> the PMC-Sierra 8070/8072 series chips.  I have also addressed
Benjamin> other various issues that were discovered during our testing
Benjamin> and verification phase, mainly with resume-from-sleep,
Benjamin> configuring PHY profiles, and using legacy interrupts.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
