From: James.Smart@Emulex.Com
Subject: RE: [PATCH 6/11]  lpfc 8.1.1 : Fixes to error handlers
Date: Mon, 28 Nov 2005 14:08:56 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C56@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:14736 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932184AbVK1TJL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:09:11 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org

This is true - when invoked via the error handler thread.  Unfortunately,
reset functions invoked via SG do not have the same behavior. There is a
rather large test suite from a big storage vendor that uses asynchronous
resets via SG extensively.

-- james.

> -----Original Message-----
> From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
> Sent: Monday, November 28, 2005 2:03 PM
> To: linux-scsi@vger.kernel.org
> Cc: Smart, James
> Subject: Re: [PATCH 6/11] lpfc 8.1.1 : Fixes to error handlers
> 
> 
> James Smart wrote:
> > - Serialize EH calls and block requests when EH function is running.
> 
> Is this necessary? From what I understood from docs or 
> comments, there 
> is nothing enqueued while an EH is run. (Furthermore, EHs are not 
> concurrent per host.) Or am I mistaken?
> -- 
> Stefan Richter
> -=====-=-=-= =-== ===--
> http://arcgraph.de/sr/
> 
