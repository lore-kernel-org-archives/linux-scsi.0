From: "Eric Raskin" <eraskin@paslists.com>
Subject: RE: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 15:36:48 -0500
Message-ID: <15ae01c50af9$42f42c40$650aa8c0@ehrpc>
References: <20050204202501.GA25126@infradead.org>
Reply-To: <eraskin@paslists.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from paslists.com ([12.170.105.210]:455 "EHLO fw.paslists.com")
	by vger.kernel.org with ESMTP id S264118AbVBDUfQ convert rfc822-to-8bit
	(ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 15:35:16 -0500
Received: from ehrpc (ehrpc.paslists.com [192.168.10.101])
	by fw.paslists.com (8.12.8/8.12.8) with ESMTP id j14KZ0o8002699
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 15:35:09 -0500
In-Reply-To: <20050204202501.GA25126@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Thanks, Christoph.  Would we use the same commands on 2.6?

----------------------------------------------------------------------------
Eric H. Raskin                                          Voice: 914-765-0500
Professional Advertising Systems Inc.                   Fax:   914-765-0503
200 Business Park Dr Suite 107                          eraskin@paslists.com
Armonk, NY 10504


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, February 04, 2005 3:25 PM
To: Eric Raskin
Cc: Linux-scsi@vger.kernel.org
Subject: Re: How to disconnect a SCSI device without crashing SLES8?

On Fri, Feb 04, 2005 at 02:12:13PM -0500, Eric Raskin wrote:
> In searching the web, I've found the "remove-scsi-device" and
> "add-scsi-device" commands that can be sent to /proc/scsi/scsi.
> 
> Does anybody know if the system will stay up if I use these commands to
> remove all my tape library devices before shutting it down?  Is this the
> proper way to repair my library without having to shut the system off?

remove-scsi-device could work, but in Linux 2.4 it's racy.

If you want to remove and add devices at runtime safely you'll have to
update to Linux 2.6.


