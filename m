From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] Added bug fixes and several features for BNX2I
Date: Thu, 06 Jan 2011 14:43:15 -0600
Message-ID: <4D262963.9060801@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1294260267-17413-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51050 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab1AFUtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 15:49:43 -0500
In-Reply-To: <1294260267-17413-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 01/05/2011 02:44 PM, Eddie Wai wrote:
> Hello,
>
> This patch set contains two fixes and added various features as titled.
> The two fixes are:
> 1 - connection cleanup fix which fixes a chip panic issue
> 2 - nopout LUN field fix which fixes nopout timeouts
>
> The features added includes TCP timestamp, jumbo MTU, text pdu support
> for discovery offload, and 57712(E) support.

All patches but "[PATCH 5/8] BNX2I: Added TCP timestamps option support" 
look ok. I am working on a common way to set tcp settings for 2.6.39, so 
lets wait on that.


>    BNX2I: Added TCP timestamps option support


