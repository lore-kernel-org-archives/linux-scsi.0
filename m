From: James.Smart@Emulex.Com
Subject: RE: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 12:25:04 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EA03@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:22192 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261788AbVASRZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 12:25:24 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org, greg@kroah.com

True. The only thing that made them FC-ish is that they were
mandated by HBAAPI.  The only other desire was to place all
hbaapi-related data in a single place so users/applications don't
have to trapse through the multiple directories in the class and
device trees.

I'll ping Greg on adding them to the common driver model code.

As for the copyright notices - I'll add them. Sorry, my lack of
procedure on kernel additions.  Just trying to be a good citizen.

-- James


> I think the hardware_version, firmware_version, rom_version and
> driver_version don't belong into the FC transport class, there's
> nothign specific to FC or even SCSI specific in them.
> 
> If you want these attributes talk to Greg about fiding a place in
> the common driver model code for them.
> 
> p.s. I was surprised to find no Emulex copyright notices in the FC
> transport implementation fields, I suspect you should add them.
