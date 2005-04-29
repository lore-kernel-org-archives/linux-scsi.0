From: James.Smart@Emulex.Com
Subject: RE: Emulex fibre channel HBA support and SAN connection
Date: Fri, 29 Apr 2005 14:16:32 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2062982@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:13193 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262862AbVD2SQn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 14:16:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: alexdeucher@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

We'll look into it...

-- james

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, April 29, 2005 2:15 PM
> To: Smart, James
> Cc: alexdeucher@gmail.com; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org
> Subject: Re: Emulex fibre channel HBA support and SAN connection
> 
> 
> On Fri, Apr 29, 2005 at 02:08:01PM -0400, 
> James.Smart@Emulex.Com wrote:
> > We are putting together such a document that will be placed
> > out on SourceForge.
> 
> My idea was to put in in the driver actually, so that the 
> ->probe routine
> can print an error message for the user.
> 
> 
