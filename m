From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: SCSI kobject unregistration ordering problem
Date: Sun, 2 Nov 2003 12:08:10 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311021208.10641.arvidjaar@mail.ru>
References: <20031013151254.521d882e.akpm@osdl.org> <20031017155008.GA1298@beaverton.ibm.com> <20031020170711.GA5183@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hueytecuilhuitl.mtu.ru ([195.34.32.123]:50957 "EHLO
	hueymiccailhuitl.mtu.ru") by vger.kernel.org with ESMTP
	id S261585AbTKBJJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Nov 2003 04:09:38 -0500
In-Reply-To: <20031020170711.GA5183@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>

On Monday 20 October 2003 21:07, Mike Anderson wrote:
[...]
>
> I posted Friday adding a release call to the scsi_disk structure and
> removing the delay call to device_del. On test8 this corrected the
> problem I was seeing of surprise removal with a mounted device. A pointer
> to the patch in the archive is below.
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106646263401437&w=2
>

sorry for late answer, I did not realize patch was already in kernel till I 
attempted to apply it.

This fixed the problem just fine, thank you.

-andrey

