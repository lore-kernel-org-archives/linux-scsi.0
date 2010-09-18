From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number
 to atomic_t
Date: Fri, 17 Sep 2010 21:56:29 -0500
Message-ID: <4C942A5D.5040109@cs.wisc.edu>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org> <4C93BB8E.2080501@cisco.com> <4C9427B6.9050404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44136 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab0IRCvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 22:51:07 -0400
In-Reply-To: <4C9427B6.9050404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On 09/17/2010 09:45 PM, Mike Christie wrote:
> The comments for serial_number say that it is only supposed to be used
> for debugging printks and most drivers use it for that. However, it
> looks like mpt and dpt_i2o are using it for error handling and/or lookup
> type of operations. I think the mpt* uses are not needed in the abort
> checks.

Oh yeah, forgot to say, for dpt I think you could just replace the 
serial_number with the host wide tagging.
