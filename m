From: James.Smart@Emulex.Com
Subject: RE: [PATCH] Add attributes to FC transport
Date: Fri, 10 Sep 2004 12:48:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C0864D1@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:12744 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267582AbUIJQsU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 12:48:20 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, Mukesh.Rajan@Emulex.Com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, brking@us.ibm.com

James,

Given the other patches that have gone in since - this proposed patch no longer makes sense.

Continue on without it - and we'll post another patch in the next couple of days.

-- James S


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of James Bottomley
> Sent: Friday, September 10, 2004 12:30 PM
> To: Rajan, Mukesh
> Cc: 'linux-scsi@vger.kernel.org'; 'andrew.vasquez@qlogic.com';
> 'brking@us.ibm.com'
> Subject: Re: [PATCH] Add attributes to FC transport
> 
> 
> On Fri, 2004-08-06 at 16:46, Rajan, Mukesh wrote:
> > We would like to export certain HBA attributes such as Port 
> Type, Port
> > Speed etc via sysfs in the lpfc driver. These attributes are more
> > representative of the transport layer and it will benefit 
> from including
> > them as generic FC transport attributes. Also the patch corrects the
> > illegal values of node_name, port_name and port_id to zero, 
> which are the
> > accepted NULL values as per the FC-GS-4 standards.
> > 
> > Please apply.
> 
> Your mailer has mangled the attached patch to add line breaks when the
> lines are > 80 chars long.  Could you send an unmangled patch, please?
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
