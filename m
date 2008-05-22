From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: iscsi update for 2.6.27
Date: Thu, 22 May 2008 12:31:04 +0300
Message-ID: <48353D58.2080109@panasas.com>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu> <48348EC0.5080905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5715 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765837AbYEVJdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 05:33:44 -0400
In-Reply-To: <48348EC0.5080905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> michaelc@cs.wisc.edu wrote:
>> This also includes from cleanup patches from Harvey Harrison. It does
>> include the patch from Boaz since I goofed and forgot that we were
> 
> This should say it does _not_ include the patch from boaz.
> 

Rrr, what a girl got to do to get a one liner in the tree around here.

You are the maintainer. Please you decide. I have sent both versions of
the patch, one hard coded 260 everywhere, second use of SCSI_MAX_VARLEN_CDB_SIZE.
As it stands now SCSI_MAX_VARLEN_CDB_SIZE definition is already in the kernel,
but the use of it is not. I have proved that the scsi standard do defines this
limit, and the confusion about it just proves that it should be defined.

[
SCSI_Primary_Commands-3-spc3r23
section 4.3.3 The variable length CDB formats:

"The ADDITIONAL CDB LENGTH field specifies the number of additional CDB bytes. 
This value in the ADDITIONAL CDB LENGTH field shall be a multiple of 4"
]

The 2 patches are here:
http://www.spinics.net/lists/linux-scsi/msg26579.html

> 
>> going to cleanup the iscsi_ecdb_ahdr 260 hardcoding usage and Boaz and James
>> are discussing where to define that. That can go in later when Boaz is
>> ready and those issues are resolved.

Please include the version you like. It looks like James has no farther response
on this issue.

Boaz

