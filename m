From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] kmalloc arguments in wrong order (53c700)
Date: Thu, 22 Jun 2006 18:42:27 -0700
Message-ID: <20060622184227.8f7a071b.rdunlap@xenotime.net>
References: <20060622204813.GY27946@ftp.linux.org.uk>
	<449B39E7.6040701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:6114 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932763AbWFWBjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 21:39:43 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2006 18:39:39 -0700
In-Reply-To: <449B39E7.6040701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: viro@ftp.linux.org.uk, torvalds@osdl.org, linux-scsi@vger.kernel.org

On Thu, 22 Jun 2006 20:46:31 -0400 Douglas Gilbert wrote:

> Al Viro wrote:
> > Could people please run make C=2 at some point?
> 
> Is "sparse" packaged somewhere?

Source tarball snapshots of it are (if you have a git aversion)
at http://www.codemonkey.org.uk/projects/git-snapshots/sparse/

I don't know of any binary packages for it.  Some distros
may do that, but it's so very easy to build from source.

---
~Randy
