From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/8] qla4xxx: Resubmission of patches to add IPv6
	support etc
Date: Thu, 24 May 2007 11:19:28 -0500
Message-ID: <1180023568.3692.39.camel@mulgrave.il.steeleye.com>
References: <1179967558.15215.16.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34147 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750731AbXEXQTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 12:19:31 -0400
In-Reply-To: <1179967558.15215.16.camel@iscsi-sles10>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

On Wed, 2007-05-23 at 17:45 -0700, David C Somayajulu wrote:
> This series of patches is a resubmission of the previous patch under the title "[RFC] [PATCH]  qla4xxx: Updated add IPv6 and misc support bugfixes cleanup" as set of smaller patches per Mike Christie's advice/feedback. They contain the following:
> 1. Support for IPv6 and QLA4032.
> 2. Bug fixes and clean up to confirm to linux coding style.

Just so you know ... I consider a patch labelled [RFC] for discussion
only ... i.e. it's not submitted for inclusion into a branch.

Additionally, if you have to add the Resubmission: piece to the subject,
do it in the initial square brackets like

[PATCH 6/8, RESUBMISSION (for the fifteenth time)] qla4xxx: ql4_isr.c support for new mbx cmds

That way I don't have to edit the subject line of everything.

Thanks,

James


