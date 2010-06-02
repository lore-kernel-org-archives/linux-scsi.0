From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [LSF/VM TOPIC] Generic SAN Management via Oracle VM Storage
 Connect Plugin.
Date: Wed, 2 Jun 2010 10:18:58 +0900
Message-ID: <20100602101830Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100401010539.GF28680@mail.oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54253 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0FBBTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 21:19:36 -0400
In-Reply-To: <20100401010539.GF28680@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel.Becker@oracle.com
Cc: lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

On Wed, 31 Mar 2010 18:05:40 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> [ I was asked to Cc: linux-scsi, so here it is ]
> 
> 
> [Topic]
> Generic SAN Management via Oracle VM Storage Connect Plugin.
> 
> [Abstract]
> Managing storage in the SAN often requires using a different tool for
> each vendor in the environment.  Oracle has defined a plugin interface
> for SAN management, the (sorry about the mouthful) Oracle VM Storage
> Connect Plugin.  The important part is that many of our storage partners
> have agreed to not only help, but actively author plugins for their
> storage hardware.
> 
> While initiated for the Oracle VM product, I've written a standalone
> application that uses the plugin, giving a unified view of storage that
> can be managed from one place.  The program will be open source, of
> course.  I'm looking for input from storage folks at LFS on what
> I can do to make this even more useful to general SAN management.

The source code is already released or will be shortly?

I'd like to know what operations exactly the interface provide (lun
create, delete, snapshot, clone, etc?).

I also like to write a plugin for tgt scsi target implementation
(http://stgt.sourceforge.net/).
