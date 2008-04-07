From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas problem
Date: Mon, 7 Apr 2008 09:16:19 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229F79FF3@NAMAIL2.ad.lsil.com>
References: <20080407010738.GB1952@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50827 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYDGPRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 11:17:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080407010738.GB1952@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org

On Sunday, April 06, 2008 7:08 PM, Wakko Warner wrote: 
> Moore, Eric wrote:
> > The other fellow was having his controller go into fault 
> state, that is not
> > the case here.   Here commands are not completing back from 
> [0:0:0:0]
> > device in the timeout period, typically 30 seconds.   Its 
> hard to tell from
> 
> Is it possible that with queue_depth > 31 was causing the 
> problem?  I read
> something about that (32 would cause the device to look like 
> it was hot
> unplugged or something.  I did not experience this though, or 
> if I did, it
> never said the device came back as I had read)
> 

Can you please download lsiutil from here:
ftp://ftp.lsi.com/HostAdapterDrivers/lsiutil

# ./lsiutil 100 > output

And send me the 'output'.   I need to see whether NCQ was enabled, and
what the SATAMaxQDepth was set to.

Eric Moore
