From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] BNX2I - update CQ arming algorith for 5771x chipsets
Date: Wed, 09 Dec 2009 20:48:05 -0600
Message-ID: <4B206165.1020803@cs.wisc.edu>
References: <1260214818.31468.98.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54766 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769AbZLJCsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2009 21:48:10 -0500
In-Reply-To: <1260214818.31468.98.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mchan@broadcom.com, poswald@novell.com

Anil Veerabhadrappa wrote:
>     * Only affects 5771x (10G chipsets) devices


Why don't you do it on 1 gig? Is it just not worth it or is it no 
possible due to some limitation?
