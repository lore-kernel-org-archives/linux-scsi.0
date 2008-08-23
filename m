From: <Shyam_Iyer@Dell.com>
Subject: RE: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
Date: Sat, 23 Aug 2008 16:40:45 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA018D73C1@blrx3m10.blr.amer.dell.com>
References: <46A00B48CC54E4468EF6911F877AC4CA018D73BB@blrx3m10.blr.amer.dell.com><20080823.012830.262443664.davem@davemloft.net><46A00B48CC54E4468EF6911F877AC4CA018D73BC@blrx3m10.blr.amer.dell.com> <20080823.022934.127206564.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:58788 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYHWLKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Aug 2008 07:10:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080823.022934.127206564.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net
Cc: akpm@linux-foundation.org, kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com, michaelc@cs.wisc.edu, swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com, leedom@chelsio.com

>Look, what you're suggesting is to change existing practice and that
doesn't belong in the discussion of the review of a specific driver.
>If you want to bring that up as a topic and change globally how that is
handled, bring that up as a seperate topic on linux-kernel.

Sounds reasonable.

>Don't bug the poor driver submitter who is just following existing and
accepted practice.

That wasn't the intention here. It rose out of the discussion that was
being suggested that DRV_MODULE_VERSION be removed and I don't think
should be done.
So, I suggested a followup suggestion from there. Will take that up as
you suggested.

-Shyam
