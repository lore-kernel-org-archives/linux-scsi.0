From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH qla2xxx] Race in handling rport deletion in Qlogic driver
 during recovery causes panic
Date: Mon, 15 Dec 2014 05:44:08 -0800
Message-ID: <20141215134408.GA31836@infradead.org>
References: <66112100.3203938.1416924145624.JavaMail.zimbra@redhat.com>
 <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLONoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 08:44:08 -0500
Content-Disposition: inline
In-Reply-To: <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <cdupuis@redhat.com>

Thanks, applied to drivers-for-3.19.
