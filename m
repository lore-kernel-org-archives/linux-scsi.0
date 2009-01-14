From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Retrying cmd when SNS Key is "Unit Attention" and the device is
 not removable
Date: Wed, 14 Jan 2009 12:46:32 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B2BE5B37C@azsmsx505.amr.corp.intel.com>
References: <1231892794.7870.54.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbZANTqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 14:46:54 -0500
In-Reply-To: <1231892794.7870.54.camel@fritz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Robert Love wrote:
> I'm not seeing commands retried when the target returns "Check
> Condition / Unit Attention" for SNS data.
> 
It looks like a fix went in about a week ago for this. I
retested with the tip and as far as I can tell it works fine.