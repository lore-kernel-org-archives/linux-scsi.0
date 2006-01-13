From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] mptsas: support basic hotplug
Date: Fri, 13 Jan 2006 09:55:47 -0600
Message-ID: <1137167747.3365.6.camel@mulgrave>
References: <20060113100905.GA26592@lst.de>
Reply-To: James.Bottomley@steeleye.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:29908 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422724AbWAMP4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 10:56:02 -0500
In-Reply-To: <20060113100905.GA26592@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, 2006-01-13 at 11:09 +0100, Christoph Hellwig wrote:
> +       struct semaphore         sas_topology_mutex;

The semaphore to mutex conversion squad will have me shot if I put that
in.  If it's just a mutex, then you need to use the new mutex types.  If
it's actually a real counting semaphore (which it doesn't look to be)
then call it a semaphore.

James


