From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: Fri, 7 Nov 2003 09:51:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031107095145.A3785@beaverton.ibm.com>
References: <1068165515.28505.29.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:64219 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264525AbTKGRwU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 12:52:20 -0500
Content-Disposition: inline
In-Reply-To: <1068165515.28505.29.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 06, 2003 at 05:38:36PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 06, 2003 at 05:38:36PM -0700, Pat LaVarre wrote:

Do you have a tar ball or such of all the code? Or is this still very much
a work in progress?

I don't see all the functions in the patch, for example, gcs_in.

I was going to say put the functions in a library, but maybe you already
are headed that way. Then create a libsgio or such, and users like
sg_utils, scsi_id, cdrecord, scsidev, etc. could link with sgio.

And lose the macros I, Y, etc, just use the function name, or at least
have more meaningful macro names.

The command line plscsi could support both long and short names (-i or
--gcs-in).

-- Patrick Mansfield
