From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] mechanism for multipath to pass information to
 hardware handler
Date: Fri, 26 Jun 2009 14:55:54 -0500
Message-ID: <1246046154.3925.80.camel@mulgrave.site>
References: <1245863681.8709.135.camel@eddie-laptop>
	 <1246043447.3925.64.camel@mulgrave.site>
	 <1246045509.14164.33.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55591 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069AbZFZTzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jun 2009 15:55:55 -0400
In-Reply-To: <1246045509.14164.33.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Christie <mchristi@redhat.com>, Edward Goggin <egoggin@vmware.com>, "Benoit, Arthur" <Benoit_Arthur@emc.com>, asson_ronald <asson_ronald@emc.com>, berthiaume_wayne <berthiaume_wayne@emc.com>

On Fri, 2009-06-26 at 12:45 -0700, Chandra Seetharaman wrote:
> Yes, Mike Christie and I were aware of this and it was one of the issue
> we were trying to resolve before we pushed scsi_dh interface upstream.
> (It is little complicated as we need the parameters to be set per
> vendor-product tuple).
> 
> The original code I ported to scsi_dh interface was from Ed Goggin(who
> was working for EMC then). IIRC, he was also aware of this issue.
> 
> When we pushed scsi_dh interface, we did get few of the EMC folks (on
> Cc) to review/test the code and they did, and this issue was not seen as
> a problem. 
> 
> We wanted to get back to that issue sometime later, got busy with other
> things, and it disappeared from my list of things-to-do as the
> regression was not seen as an issue (till now :)... I will get back to
> it.

One way around this might simply be to make the device_handlers create a
sysfs interface for additional parameters.  Then the multipath command
can feed them (or in a pinch, users relying on the features can pass
them in manually).  Right at the moment having no possible work around
does appear to be an issue.

James


