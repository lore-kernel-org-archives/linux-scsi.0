From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: always release crypto
Date: Mon, 06 Nov 2006 12:06:01 -0600
Message-ID: <454F7989.60502@cs.wisc.edu>
References: <20061104233311.GA14929@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:64418 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1753746AbWKFSGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 13:06:09 -0500
In-Reply-To: <20061104233311.GA14929@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: linux-scsi@vger.kernel.org, open-iscsi <open-iscsi@googlegroups.com>

Pete Wyckoff wrote:
> Unconditionally free crypto state, as it is always allocated during
> TCP connection creation.  Without this, crypto structures leak and
> crc32c module refcounts grow as connections are created and
> destroyed.
> 

Thanks, merged. It is in the next bugfix patchset.
