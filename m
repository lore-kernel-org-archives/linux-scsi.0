From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][BUGFIX] : Megaraid patch for 2.6 1/5
Date: Fri, 20 Feb 2004 00:10:48 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <403596D8.8020509@pobox.com>
References: <1077242738.12567.76.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1077242738.12567.76.camel@morsel.kungfoocoder.org>
To: Paul Wagland <paul@kungfoocoder.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>, akpm@osdl.org, torvalds@osdl.org, James.Bottomley@HansenPartnership.com, atulm@lsil.com
List-Id: linux-scsi@vger.kernel.org

Patches 1-5 look OK to me.

If you are attempting to follow LSI's megaraid (in 2.4 only, sigh), 
patch #4 may wind up causing you grief in the future.  Hopefully Atul 
will pick it up, though :)

	Jeff
