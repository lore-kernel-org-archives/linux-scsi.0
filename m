From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: Wed, 24 Mar 2004 17:28:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFBF4BB3D4.D3E1B9A6-ONC1256E61.005A3D8C-C1256E61.005AAB6E@de.ibm.com>
References: <1080142505.2706.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:23704 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S263789AbUCXR2K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 12:28:10 -0500
In-Reply-To: <1080142505.2706.25.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

> > upon scsi_remove_device the sd driver tries to send out a 
SYNCHRONIZE_CACHE
> > command (sd_shutdown) which is not possible because the sdev_state for 
the
> > device in question is already SDEV_DEL.
> How about the attached instead.  That forces every deleted device to go
> through CANCEL (uncompiled, but you can test it...)

Your patch works fine for me. Are you going to apply that one?

Heiko

