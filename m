From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] zfcp: Invalid locking order
Date: Wed, 7 Feb 2007 17:06:43 +0100
Message-ID: <20070207160643.GE30311@alberich.amd.com>
References: <200702071317.58026.swen.schillig@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:30079 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030287AbXBGQHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 11:07:00 -0500
In-Reply-To: <200702071317.58026.swen.schillig@freenet.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen.schillig@freenet.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 07, 2007 at 01:17:57PM +0100, Swen Schillig wrote:
> From: Swen Schillig <swen@vnet.ibm.com>
> 
> Invalid locking order. Kernel hangs after trying to take two locks
> which are dependend on each other. Introducing temporary variable
> to free requests. Free lock after requests are copied.
>     

I am just curious. You didn't mention which locks are causing the dead
lock.

I've glanced through the code and it seems that locking order
of abort_lock and req_list_lock for adapters is inconsistent.
Is that the bug you try to fix?


Regards,

Andreas



