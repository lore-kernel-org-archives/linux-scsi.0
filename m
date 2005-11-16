From: James.Smart@Emulex.Com
Subject: RE: channel busy
Date: Wed, 16 Nov 2005 11:11:41 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276BA4@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31213 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030384AbVKPQLr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 11:11:47 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com, linux-scsi@vger.kernel.org

True - and we've been dancing around target busy as well.  Basically,
if there's an HCIL, any component of the HCIL could potentially be busy.
And, stirring the pot, there could be different queuing/resource limits
at each point as well.

-- james

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Jeff Garzik
> Sent: Wednesday, November 16, 2005 10:51 AM
> To: SCSI Mailing List
> Subject: channel busy
> 
> 
> It would be nice if the SCSI core supported the concept of "channel 
> busy".  SCSI understands host-busy and device-busy.
> 
> Right now libata allocates one scsi host per ATA port largely due to 
> SCSI implementation details, and I would like to get away from that.
> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
