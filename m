From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain
 backward compatibility
Date: Fri, 11 Apr 2003 02:08:00 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304110157460.12110-100000@serv>
References: <200304101339.49895.pbadari@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpzilla1.xs4all.nl ([194.109.127.137]:27400 "EHLO
	smtpzilla1.xs4all.nl") by vger.kernel.org with ESMTP
	id S264249AbTDJX41 (for <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2003 19:56:27 -0400
In-Reply-To: <200304101339.49895.pbadari@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On Thu, 10 Apr 2003, Badari Pulavarty wrote:

> This patch addresses the backward compatibility with device nodes
> issue. All the new disks will be addressed by only last major.

This nicely demonstrates, that it's not exactly becoming nicer, when one 
has to deal with compatibility. This is one more reason to at least 
consider a more general solution, from which all drivers can benefit from.

bye, Roman

