From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RESENT] hptiop: adding new firmware interface and more
 PCI device IDs
Date: Thu, 30 Aug 2007 06:53:25 -0400
Message-ID: <46D6A1A5.2000309@garzik.org>
References: <200605101704.27491.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com> <200708301635.42481.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbXH3Kx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2007 06:53:29 -0400
In-Reply-To: <200708301635.42481.linux@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com

HighPoint Linux Team wrote:
> updated patch based on Jeff Garzik's comments.
> 
> - check adapter firmware version and use appropriate interface accordingly
> - add new PCI device IDs and use PCI_VDEVICE macro
> - update driver version string
> - remove unused data structures
> - remove unnecessary typecasts
> 
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>

ACK


