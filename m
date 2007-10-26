From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/1] scsi: fix a few misleading comments in scsi.c
Date: Fri, 26 Oct 2007 08:37:22 -0600
Message-ID: <20071026143722.GS27248@parisc-linux.org>
References: <20071026134217.GA16709@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58387 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXJZOhX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 10:37:23 -0400
Content-Disposition: inline
In-Reply-To: <20071026134217.GA16709@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2007 at 08:42:17AM -0500, scameron@beardog.cca.cpqcorp.net wrote:
> - * needs to be release with scsi_host_put once you're done with it.
> + * needs to be release with scsi_device_put once you're done with it.

s/release/released/ as well?

> - * needs to be release with scsi_host_put once you're done with it.
> + * needs to be release with scsi_device_put once you're done with it.

ditto

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
