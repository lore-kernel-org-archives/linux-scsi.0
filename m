From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] MPT Fusion driver update
Date: Sat, 8 Nov 2003 08:33:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031108083355.A18790@infradead.org>
References: <1068219506.1831.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:21764 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261656AbTKHId5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2003 03:33:57 -0500
Content-Disposition: inline
In-Reply-To: <1068219506.1831.8.camel@mulgrave>; from James.Bottomley@steeleye.com on Fri, Nov 07, 2003 at 09:38:25AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 07, 2003 at 09:38:25AM -0600, James Bottomley wrote:
> This one's from: Eric Moore <emoore@lsil.com>
> 
> Changes in patch
> * removed __init from mptscsih_setup
> * removed __init from get_setup_token
> * changed copyright from 2002 to 2003
> * added new mailto, and removed Pam.Delaney
> * added some fix for 32bit emulation when unloading mptctl module

The patch doesn't look bad but doesn't fix the real problems the driver
has either..

