From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on SDEV_BLOCK vs. SDEV_QUIESCE
Date: Tue, 25 Sep 2007 09:56:17 +0200
Message-ID: <200709250956.18215.oliver@neukum.org>
References: <200709250934.30213.oliver@neukum.org> <46F8BBEC.4090602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:41275 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXIYHzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 03:55:21 -0400
In-Reply-To: <46F8BBEC.4090602@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Dienstag 25 September 2007 schrieb Hannes Reinecke:
> Oliver Neukum wrote:
> > Hi,
> > 
> > what is the difference between these states? What function should
> > I call to block a device in order to securely flush the caches?
> > 
> SDEV_BLOCK blocks _any_ commands from the midlayer; eg. if the LLDD
> is doing some internal recovery.
> SDEV_QUIESCE only blocks 'normal' data commands; others (like control
> commands) can still get through.
> 
> So for flushing you should use SDEV_QUIESCE.

Thank you, that's very helpful.

	Regards
		Oliver

