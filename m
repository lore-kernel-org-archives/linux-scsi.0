From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI/SD layer modifying sdev_state to SDEV_RUNNING when it is
 already blocked by LLD
Date: Fri, 17 Oct 2014 06:15:30 -0700
Message-ID: <20141017131530.GC16538@infradead.org>
References: <CAM+6EX1gQycpym+867=2UwJMTfwOTiL9LQhtL9WPp6E0ZUZ8mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaJQNPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:15:30 -0400
Content-Disposition: inline
In-Reply-To: <CAM+6EX1gQycpym+867=2UwJMTfwOTiL9LQhtL9WPp6E0ZUZ8mg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>

On Wed, Oct 01, 2014 at 03:25:54PM -0600, Praveen Krishnamoorthy wrote:
> Therefore, we would like to understand if the behavior in the SCSI
> layer could be changed by either of these 2 options in the future.
> 
> 1. Ensuring the SCSI/SD layer doesn't set the device state to
> SDEV_RUNNING without checking if it is already in SDEV_BLOCKED state.

I think this is the right way to go.

