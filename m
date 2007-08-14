From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 4/6] mpt fusion: Creation of mptsas.h header file
Date: Tue, 14 Aug 2007 12:49:34 -0600
Message-ID: <20070814184934.GS16277@parisc-linux.org>
References: <20070814104537.GD9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47470 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbXHNStf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 14:49:35 -0400
Content-Disposition: inline
In-Reply-To: <20070814104537.GD9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Tue, Aug 14, 2007 at 04:15:38PM +0530, Prakash, Sathya wrote:
> The data structure definitions from mptsas.c are moved to a new header file mptsas.h

Why?  Are they used outside mptsas.c in some future patch?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
