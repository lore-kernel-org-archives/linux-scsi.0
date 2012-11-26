From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 09/11] srp_transport: Simplify attribute initialization
 code
Date: Mon, 26 Nov 2012 00:02:22 -0500
Message-ID: <1353906142.23660.13.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <a55a3dbccc3742a817aa0b52e4e1333b7949af01.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:35460 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2KZFC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 00:02:28 -0500
In-Reply-To: <a55a3dbccc3742a817aa0b52e4e1333b7949af01.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org

On Sun, 2012-11-25 at 23:44 -0500, David Dillow wrote:
> From: David Dillow <dillowda@ornl.gov
> 
> From: Bart Van Assche <bvanassche@acm.org>
> 
> Eliminate the private_rport_attrs[] array and the SETUP_*() macros
> used to set up that array since the information in that array
> duplicates the information in the static device attributes. Also,
> verify whether SRP_RPORT_ATTRS is large enough since it is easy
> to forget to update that macro when adding new attributes.

Bah, screwed up some edits for the batch email. This one (and Vu's) is
properly attributed in the repository.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

