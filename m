From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch
Date: Mon, 3 Nov 2003 15:00:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031103150025.A9358@beaverton.ibm.com>
References: <47F3C2BE74738E4683574107469DFA201DF578@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:41459 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263472AbTKCXBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2003 18:01:08 -0500
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA201DF578@XYUSEX01.xyus.xyratex.com>; from Frank_Borich@us.xyratex.com on Mon, Nov 03, 2003 at 02:45:46PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org, David Lethe <David_Lethe@us.xyratex.com>, Bill Krempp <Bill_Krempp@us.xyratex.com>

On Mon, Nov 03, 2003 at 02:45:46PM -0800, Frank Borich wrote:

> numbering.  Because we sell only to OEMs, the Vendor ID will change.
> The logic in scsi_scan.c will not handle a wild card or "NULL" for the
> Vendor ID.  Can we 
> add code to allow a wildcard for this?  The Model "Kashi-II" will remain

Can you instead modify the device to return as SCSI-3?

That is a much better solution. 

And, for 2.6 we will only use REPORT LUNS if the device is SCSI-3 or up.

You could certainly submit a patch for 2.4 and 2.6 to wild card the vendor
field.

-- Patrick Mansfield
