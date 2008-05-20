From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Date: Tue, 20 May 2008 10:21:39 -0700
Message-ID: <20080520172139.GA11666@kroah.com>
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com> <20080520030232.fc91b64e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37786 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764907AbYETRZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 13:25:55 -0400
Content-Disposition: inline
In-Reply-To: <20080520030232.fc91b64e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, matthew@wil.cx, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Converting class semaphore to mutex cause lockdep warnings due to
> > class_interface_register/unregister will possible call device_add/del
> 
> Shouldn't we just fix that?

Um, no, that's a "feature" that some types of hardware and interfaces
require.

This is one reason I really don't like this type of conversion, it's
causing lots of problems for no known gain.

So I would just recommend dropping this patch set, the current "convert
class semaphore to a mutex" patch in the -mm tree is already causing
lockdep warnings, and trying to do something like this isn't really
going to solve the root problem here.

thanks,

greg k-h
