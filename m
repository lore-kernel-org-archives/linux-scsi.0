From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Thu, 7 Apr 2005 11:31:23 +0100
Message-ID: <20050407103123.GB9586@infradead.org>
References: <42550173.1040503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9118 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262424AbVDGKb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2005 06:31:27 -0400
Content-Disposition: inline
In-Reply-To: <42550173.1040503@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 07, 2005 at 11:46:27AM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> /proc/scsi/scsi currently has a very dumb implementation of the seq_file
> api which causes 'cat /proc/scsi/scsi' to return with -ENOMEM when a
> large amount of devices are connected.

/proc/scsi/scsi is deprecated and even only compiled in if
"legacy /proc/scsi/ support" is enabled.  Please move over to lssci which
is using sysfs ASAP.

