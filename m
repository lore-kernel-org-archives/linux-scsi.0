From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi device recovery
Date: Wed, 12 Dec 2007 06:39:27 -0700
Message-ID: <20071212133927.GI26334@parisc-linux.org>
References: <200712121354.14474.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33459 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbXLLNj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 08:39:28 -0500
Content-Disposition: inline
In-Reply-To: <200712121354.14474.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> below is a patch introducing device recovery, trying to prevent i/o errors 
> when a DID_NO_CONNECT or SOFT_ERROR does happen.

Why doesn't the regular scsi_eh do what you need?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
