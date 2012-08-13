From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/7] Removing the iscsi_data_pdu setting.
Date: Mon, 13 Aug 2012 13:41:59 -0500
Message-ID: <56D13CD3-BBFF-47F2-89AB-A12996662822@cs.wisc.edu>
References: <881ee591-57a1-4fc9-a509-fda0d864c850@exht1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53900 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab2HMSmD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 14:42:03 -0400
In-Reply-To: <881ee591-57a1-4fc9-a509-fda0d864c850@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>


On Aug 13, 2012, at 5:29 AM, John Soni Jose <sony.john-n@emulex.com> wrote:

> The setting of iscsi_data_pdu is not required anymore,
> as this was required for BE1 adapters only.
> 

Were those released and supported by the upstream kernel in previous kernels?
