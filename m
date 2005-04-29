From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Fri, 29 Apr 2005 11:11:01 +0100
Message-ID: <20050429101101.GC3342@infradead.org>
References: <OF4CE413A0.DAB8B74B-ONC1256FF0.00505593-C1256FF0.0052A229@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2711 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262244AbVD2KLP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 06:11:15 -0400
Content-Disposition: inline
In-Reply-To: <OF4CE413A0.DAB8B74B-ONC1256FF0.00505593-C1256FF0.0052A229@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: dougg@torque.net, andrew.patterson@hp.com, Eric.Moore@lsil.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Madhuresh_Nagshain@adaptec.com, mike.miller@hp.com

On Wed, Apr 27, 2005 at 04:54:53PM +0200, Martin Peschke3 wrote:
> Similarly, in the case of Fibre Channel, a common N_Port or
> SCSI target device discovery, preferably in user space, seems
> to be desirable.

Did I tell you zfcp needs some updates to use all features of the FC
transport class?

> This would require some CT and / or ELS
> passthrough interface, for example in order to issue queries
> to fabric switches.

Emulex plans to contribute such interfaces to the FC transport class.
It would be nice if zfcp could catch up on full usage of the transport
class, or did I mention that already? ;-)

