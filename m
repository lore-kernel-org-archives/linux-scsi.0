From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] iscsi transport : add sgio pass-thru support
Date: Mon, 02 Nov 2009 17:55:08 -0600
Message-ID: <4AEF715C.4030700@cs.wisc.edu>
References: <1256853056.7154.6.camel@wookie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58369 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbZKBXzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 18:55:10 -0500
In-Reply-To: <1256853056.7154.6.camel@wookie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> This patch implements the same infrastructure as found in the FC transport
> for sgio request/response handling.
> 
> The patch creates (and exports to userland) a new header - scsi_bsg_iscsi.h
> 
> 

Sorry for the late reply. I am trying to sell my house and move.


Based on your experience with fc bsg support, do you think there is some 
common code? It looks like a lot of this is generic. I just started 
looking at the fc bsg stuff again, so I am not sure ATM.
