From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Mon, 7 Jan 2008 23:06:55 +0100
Message-ID: <200801072306.56227.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0801071632180.6739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:37031 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYAGWGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 17:06:31 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801071632180.6739-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

Am Montag, 7. Januar 2008 22:34:52 schrieb Alan Stern:
> On Mon, 7 Jan 2008, Oliver Neukum wrote:
> 
> > Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> > > When all the devices under a host are suspended, the LLD is informed 
> > > (via a new "autosuspend" method in the host template) so that it can
> > 
> > That is most certainly a mistake.
> 
> Why?

You'll have to add this method whenever a new subsystem is affected
by power management. Besides what are the semantics of this method?
May suspend() be called after autosuspend() ? If not, will resume() be
called or autoresume() ?

	Regards
		Oliver
