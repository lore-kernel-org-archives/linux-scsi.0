From: "Robert J. Adams (jason)" <radams@siscom.net>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Wed, 04 Feb 2004 13:39:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40213C5A.9060006@siscom.net>
References: <A979D299E02AD31188EA0000834A03D208758308@S64P17BIA40>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from counterstrike.siscom.net ([209.251.2.97]:13837 "EHLO siscom.net")
	by vger.kernel.org with ESMTP id S263930AbUBDSjW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2004 13:39:22 -0500
In-Reply-To: <A979D299E02AD31188EA0000834A03D208758308@S64P17BIA40>
List-Id: linux-scsi@vger.kernel.org
To: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

EXT / DEVOTEAM VAROQUI Christophe wrote:

> Which path would you expect to mount by specifying the WWID ?

In Solaris it's possible to tie down a particular WWN to a device, 
otherwise the device my be detected at a different point at the next 
boot (thus get assigned a different /dev/sdX). Is this possible w/ Linux?

Thanks,
jason
NH
